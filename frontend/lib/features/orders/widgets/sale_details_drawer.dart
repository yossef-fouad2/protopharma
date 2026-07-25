import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/app_text_styles.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';

/// Right-hand sliding drawer that shows the itemised breakdown of a [SaleModel].
///
/// Mirrors the visual pattern used in the inventory drug detail drawer so the
/// UX stays consistent across the app.
class SaleDetailsDrawer extends StatelessWidget {
  const SaleDetailsDrawer({super.key, required this.sale});

  final SaleModel sale;

  static Future<void> show(BuildContext context, {required SaleModel sale}) {
    final width = MediaQuery.of(context).size.width;
    final panelWidth = width < 600 ? width : 460.0;

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) {
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: panelWidth,
            height: double.infinity,
            child: Material(
              color: AppColors.surface,
              child: SaleDetailsDrawer(sale: sale),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateTime(sale.createdAt);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sale ${sale.reference}', style: AppTextStyles.h2),
                      const SizedBox(height: 2),
                      Text(
                        '$dateStr · ${sale.paymentMethod.label} · ${sale.userName}',
                        style: AppTextStyles.tableCell.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Line items table
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle('Items'),
                const SizedBox(height: 8),
                _lineHeader(),
                const Divider(height: 1),
                ...sale.items.map(_lineRow),
              ],
            ),
          ),

          // Total footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.titleMedium),
                Text(
                  '${sale.totalAmount.toStringAsFixed(2)} EGP',
                  style: AppTextStyles.cairoBold.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String label) => Text(
    label.toUpperCase(),
    style: AppTextStyles.tableCell.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
      color: AppColors.textMuted,
    ),
  );

  Widget _lineHeader() {
    TextStyle h = AppTextStyles.tableCell.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Drug', style: h)),
          Expanded(
            child: Text('Qty', style: h, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text('Unit', style: h, textAlign: TextAlign.right),
          ),
          Expanded(
            child: Text('Total', style: h, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _lineRow(SaleItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.drugName,
              style: AppTextStyles.tableCell.copyWith(
                color: AppColors.textHeadline,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            child: Text(
              item.priceAtSale.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            child: Text(
              item.lineTotal.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: AppTextStyles.tableCell.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textHeadline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d  $hh:$mm';
  }
}
