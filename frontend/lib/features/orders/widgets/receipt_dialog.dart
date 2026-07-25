import 'package:flutter/material.dart';

import '../../../core/config/app_text_styles.dart';
import '../../../core/config/app_colors.dart';
import '../models/sale_model.dart';

/// Success / receipt dialog shown after a checkout completes.
///
/// Displays the sale reference, payment method, an itemised line breakdown, and
/// the grand total. Use [ReceiptDialog.show] to open it.
class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({super.key, required this.sale});

  final SaleModel sale;

  static Future<void> show(BuildContext context, {required SaleModel sale}) {
    return showDialog<void>(
      context: context,
      builder: (_) => ReceiptDialog(sale: sale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success badge
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text('Order Completed', style: AppTextStyles.h2)),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Sale ${sale.reference} · ${sale.paymentMethod.label}',
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Line items
              ...sale.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.drugName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.tableCell.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textHeadline,
                              ),
                            ),
                            Text(
                              '${item.quantity} × ${item.priceAtSale.toStringAsFixed(2)}',
                              style: AppTextStyles.tableCell.copyWith(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item.lineTotal.toStringAsFixed(2),
                        style: AppTextStyles.tableCell.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textHeadline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Grand total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Paid', style: AppTextStyles.titleMedium),
                  Text(
                    '${sale.totalAmount.toStringAsFixed(2)} EGP',
                    style: AppTextStyles.cairoBold.copyWith(fontSize: 20),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
