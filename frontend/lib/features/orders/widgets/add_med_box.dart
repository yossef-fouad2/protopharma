import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_text_styles.dart';

import '../../drugs/repositories/drugs_repository.dart';
import '../../inventory/inventory_cubit.dart';
import '../../inventory/inventory_state.dart';
import '../../inventory/widgets/display_table.dart';
import '../../inventory/widgets/search_toolbar.dart';

class AddMedBox extends StatelessWidget {
  const AddMedBox({super.key});

  @override
  Widget build(BuildContext context) {
    //wrap it with bloc provider to pass the cubit to the display table and search toolbar
    return BlocProvider(
      create: (_) =>
          InventoryCubit(drugRepository: context.read<DrugsRepository>()),
      child: Flexible(
        child: Container(
          width: 700,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SearchToolbar(),
                //to-do wrap the table with a bloc builder to get the data from the inventory cubit
                BlocBuilder<InventoryCubit, InventoryState>(
                  builder: (context, state) {
                    return DisplayTable(
                      columns: const [
                        DrugTableColumn.medicationName,
                        DrugTableColumn.category,
                        DrugTableColumn.route,
                        DrugTableColumn.price,
                      ],
                      drugData: [], // Replace with actual data from the cubit
                      onRowTap: (drug) {
                        // TODO: Add this drug to the current order.
                      },
                    );
                  },
                ),
                Icon(Icons.add, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('Add Medicine', style: AppTextStyles.titleMedium),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
