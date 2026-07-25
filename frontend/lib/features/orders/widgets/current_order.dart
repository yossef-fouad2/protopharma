import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../../core/config/app_colors.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';
import '../models/order_item.dart';
import 'checkout_button.dart';

class CurrentOrder extends StatelessWidget {
  const CurrentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 400,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(itemCount: state.itemCount),
                const Divider(color: Colors.grey, thickness: 1, height: 5),
                Expanded(
                  child: state.items.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _OrderCard(item: state.items[index]),
                        ),
                ),
                _TotalsFooter(state: state),
                CheckoutButton(enabled: state.items.isNotEmpty),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Panel header: title + a dark pill badge showing the item count.
class _Header extends StatelessWidget {
  const _Header({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            'Current Order',
            style: AppTextStyles.cairoBold.copyWith(fontSize: 18),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textHeadline,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
              style: AppTextStyles.tableCell.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Shown when no medications have been added yet.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.medication_outlined,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No medications added yet',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a medication on the left to add it.',
            style: AppTextStyles.tableCell.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// A single order line: name, subtitle, quantity stepper, remove, line total.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final drug = item.drug;
    final cubit = context.read<OrderCubit>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  drug.commercialNameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.tableCell.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHeadline,
                  ),
                ),
              ),
              InkWell(
                onTap: () => cubit.removeDrug(drug.id!),
                borderRadius: BorderRadius.circular(999),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${drug.scientificName} · ${drug.route}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.tableCell.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const Divider(height: 16),
          Row(
            children: [
              Text(
                'QTY',
                style: AppTextStyles.tableCell.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.04,
                ),
              ),
              const SizedBox(width: 8),
              _QtyStepper(item: item),
              const Spacer(),
              Text(
                item.lineTotal.toStringAsFixed(2),
                style: AppTextStyles.tableCell.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeadline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Rounded `-  qty  +` control that mutates the order via [OrderCubit].
class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final drugId = item.drug.id!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: () => cubit.decrement(drugId),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.border),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: AppTextStyles.tableCell.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textHeadline,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: () => cubit.addDrug(item.drug),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Icon(icon, size: 16, color: AppColors.textBody),
      ),
    );
  }
}

/// Blue-tinted totals block at the bottom of the panel.
class _TotalsFooter extends StatelessWidget {
  const _TotalsFooter({required this.state});

  final OrderState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row('Subtotal', state.subtotal.toStringAsFixed(2)),
          const SizedBox(height: 4),
          _row(
            'Insurance Coverage',
            '-${state.insuranceCoverage.toStringAsFixed(2)}',
            valueColor: AppColors.success,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Due',
                style: AppTextStyles.cairoBold.copyWith(fontSize: 18),
              ),
              Text(
                state.totalDue.toStringAsFixed(2),
                style: AppTextStyles.cairoBold.copyWith(fontSize: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.tableCell),
        Text(
          value,
          style: AppTextStyles.tableCell.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textHeadline,
          ),
        ),
      ],
    );
  }
}
