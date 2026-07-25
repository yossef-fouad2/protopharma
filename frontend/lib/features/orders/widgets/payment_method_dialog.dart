import 'package:flutter/material.dart';

import '../../../core/config/app_text_styles.dart';
import '../../../core/config/app_colors.dart';
import '../models/sale_model.dart';

/// A small modal that lets the cashier pick how the customer is paying.
///
/// Returns the chosen [PaymentMethod] via [Navigator.pop], or `null` if the
/// dialog was dismissed. Use [PaymentMethodDialog.show] to open it.
class PaymentMethodDialog extends StatelessWidget {
  const PaymentMethodDialog({super.key, required this.total});

  /// The order total shown in the header so the cashier can confirm the amount.
  final double total;

  /// Opens the dialog and resolves to the selected method (or null if cancelled).
  static Future<PaymentMethod?> show(
    BuildContext context, {
    required double total,
  }) {
    return showDialog<PaymentMethod>(
      context: context,
      builder: (_) => PaymentMethodDialog(total: total),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select Payment Method', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text(
                'Total due: ${total.toStringAsFixed(2)} EGP',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 20),
              for (final method in PaymentMethod.values) ...[
                _PaymentOption(
                  method: method,
                  onTap: () => Navigator.of(context).pop(method),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single tappable payment-method row (icon + label).
class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.method, required this.onTap});

  final PaymentMethod method;
  final VoidCallback onTap;

  IconData get _icon => switch (method) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.card => Icons.credit_card_outlined,
    PaymentMethod.insurance => Icons.health_and_safety_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(_icon, size: 22, color: AppColors.primaryTeal),
              const SizedBox(width: 12),
              Text(method.label, style: AppTextStyles.titleMedium),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
