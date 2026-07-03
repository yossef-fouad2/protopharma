import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/core/config/app_text_styles.dart';
import 'package:protopharma/data/app_database.dart';

import '../../drugs/models/drug_model.dart';

class DisplayTable extends StatelessWidget {
  const DisplayTable({
    super.key,
    required this.columnNames,
    required this.drugData,
  });

  final List<String> columnNames;
  final List<DrugModel> drugData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
          2: FlexColumnWidth(2),   // Scientific Name
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
            decoration:BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            children: columnNames
                .map(
                  (name) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textHeadline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          ...drugData.map(
            (drug) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        drug.commercialNameEn,
                        style: AppTextStyles.tableCell.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHeadline,
                        ),
                      ),
                      if (drug.commercialNameAR.isNotEmpty)
                        Text(
                          drug.commercialNameAR,
                          style: AppTextStyles.tableCell.copyWith(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drug.drugClass,
                    style: AppTextStyles.tableCell,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drug.scientificName,
                    style: AppTextStyles.tableCell,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drug.manufacturer,
                    style: AppTextStyles.tableCell,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drug.route,
                    style: AppTextStyles.tableCell,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drug.priceEGP.toStringAsFixed(2),
                    style: AppTextStyles.tableCell,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
