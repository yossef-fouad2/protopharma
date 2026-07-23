import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../drugs/models/drug_model.dart';

enum DrugTableColumn {
  medicationName,
  category,
  scientificName,
  stock,
  route,
  price,
}

class DisplayTable extends StatelessWidget {
  const DisplayTable({
    super.key,
    required this.columns,
    required this.drugData,
    this.onRowTap,
  });

  final List<DrugTableColumn> columns;
  final List<DrugModel> drugData;

  /// Called when a drug row is tapped (opens the detail drawer).
  final ValueChanged<DrugModel>? onRowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // Medication name
          1: FlexColumnWidth(1.5), // Category
          2: FlexColumnWidth(2), // Scientific Name
          3: FlexColumnWidth(1.8), // Stock Level
          4: FlexColumnWidth(1.2), // Route
          5: FlexColumnWidth(1.5), // Price (EGP)
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: const TableBorder(
          horizontalInside: BorderSide(color: AppColors.border, width: 1),
        ),
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            children: columns
                .map(
                  (column) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      _columnTitle(column),
                      style: AppTextStyles.tableCell.copyWith(
                        fontSize: 12,
                        color: AppColors.textBody,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.04,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          ...drugData.map(
            (drug) => TableRow(
              children: columns
                  .map((column) => _columnCell(drug, column))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _columnTitle(DrugTableColumn column) {
    return switch (column) {
      DrugTableColumn.medicationName => 'Medication name',
      DrugTableColumn.category => 'Category',
      DrugTableColumn.scientificName => 'Scientific Name',
      DrugTableColumn.stock => 'Stock',
      DrugTableColumn.route => 'Route',
      DrugTableColumn.price => 'Price (EGP)',
    };
  }

  Widget _columnCell(DrugModel drug, DrugTableColumn column) {
    return switch (column) {
      DrugTableColumn.medicationName => _cell(
        drug,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              drug.commercialNameEn,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: AppTextStyles.tableCell.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textHeadline,
              ),
            ),
            if (drug.commercialNameAR.isNotEmpty)
              Text(
                drug.commercialNameAR,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tableCell.copyWith(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
      DrugTableColumn.category => _cell(
        drug,
        Text(
          drug.drugClass,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.tableCell,
        ),
      ),
      DrugTableColumn.scientificName => _cell(
        drug,
        Text(
          drug.scientificName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.tableCell,
        ),
      ),
      DrugTableColumn.stock => _cell(drug, _StockBadge(drug: drug)),
      DrugTableColumn.route => _cell(
        drug,
        Text(
          drug.route,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.tableCell,
        ),
      ),
      DrugTableColumn.price => _cell(
        drug,
        Text(drug.priceEGP.toStringAsFixed(2), style: AppTextStyles.tableCell),
      ),
    };
  }

  /// Wraps a cell's [child] in padding and, when [onRowTap] is set, makes it a
  /// tap target that opens the detail drawer for [drug].
  ///
  /// A Flutter [Table] can't wrap a whole row in a gesture detector, so each
  /// cell carries the tap handler to make the entire row feel clickable.
  Widget _cell(DrugModel drug, Widget child) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: child,
    );
    if (onRowTap == null) return content;
    return TableRowInkWell(onTap: () => onRowTap!(drug), child: content);
  }
}

/// Colored badge showing a drug's total stock with a semantic status color.

///
///  - red    = out of stock (0)
///  - amber  = low stock (<= [DrugModel.lowStockThreshold])
///  - green  = healthy stock
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.drug});

  final DrugModel drug;

  @override
  Widget build(BuildContext context) {
    final (Color color, String label) = switch (drug.stockStatus) {
      StockStatus.outOfStock => (AppColors.error, 'Out of stock'),
      StockStatus.low => (AppColors.warning, 'Low: ${drug.stock}'),
      StockStatus.inStock => (AppColors.success, '${drug.stock} in stock'),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tableCell.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
