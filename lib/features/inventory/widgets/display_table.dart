import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/data/tables/drug_table.dart';

class DisplayTable extends StatelessWidget {
  const DisplayTable({
    super.key,
    required this.columnNames,
    required this.drugData,
  });

  final List<String> columnNames;
  final List<DrugTableData> drugData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(color: AppColors.border),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            children: columnNames.map((name) => Text(name)).toList(),
          ),
        ],
      ),
    );
  }
}
