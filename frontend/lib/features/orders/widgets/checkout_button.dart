import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_text_styles.dart';
import '../../../core/config/app_colors.dart';
import '../cubit/order_cubit.dart';
import '../cubit/sales_cubit.dart';
import 'payment_method_dialog.dart';
import 'receipt_dialog.dart';

/// Full-width dark checkout button.
///
/// On tap it asks for a payment method, records the sale via [SalesCubit],
/// clears the active cart via [OrderCubit], and shows a receipt dialog.
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key, required this.enabled});

  final bool enabled;

  Future<void> _checkout(BuildContext context) async {
    final orderCubit = context.read<OrderCubit>();
    final salesCubit = context.read<SalesCubit>();
    final cart = orderCubit.state.items;
    if (cart.isEmpty) return;

    // 1. Ask how the customer is paying.
    final method = await PaymentMethodDialog.show(
      context,
      total: orderCubit.state.totalDue,
    );
    if (method == null || !context.mounted) return;

    // 2. Record the sale (snapshot of the current cart). This also deducts the
    //    sold units from inventory batches in FIFO order.
    final sale = await salesCubit.checkout(
      cartItems: cart,
      paymentMethod: method,
    );
    if (!context.mounted) return;

    // 3. Empty the active cart.
    orderCubit.clear();

    // 4. Show the receipt / success dialog.
    if (context.mounted) {
      await ReceiptDialog.show(context, sale: sale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: enabled ? () => _checkout(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textHeadline,
            foregroundColor: AppColors.surface,
            disabledBackgroundColor: AppColors.border,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.point_of_sale_outlined, size: 20),
          label: Text(
            'Proceed to Checkout',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.surface),
          ),
        ),
      ),
    );
  }
}
