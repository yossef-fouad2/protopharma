import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../drugs/repositories/drugs_repository.dart';
import '../../inventory/inventory_cubit.dart';
import '../../inventory/inventory_state.dart';
import '../../inventory/widgets/display_table.dart';
import '../../inventory/widgets/pagination_bar.dart';
import '../../inventory/widgets/search_toolbar.dart';
import '../cubit/order_cubit.dart';
import '../cubit/sales_cubit.dart';
import '../cubit/sales_state.dart';

class AddMedBox extends StatelessWidget {
  const AddMedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          InventoryCubit(drugRepository: context.read<DrugsRepository>()),
      // When a sale is recorded (SalesState.sales grows), refresh the drug
      // table so the newly-deducted stock is reflected in the listing.
      child: BlocListener<SalesCubit, SalesState>(
        listenWhen: (prev, curr) => prev.sales.length != curr.sales.length,
        listener: (context, _) => context.read<InventoryCubit>().reload(),
        child: _AddMedBoxBody(),
      ),
    );
  }
}

class _AddMedBoxBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<InventoryCubit, InventoryState>(
                  builder: (context, state) {
                    if (state is InventoryInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is InventoryFailure) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (state is InventorySuccess) {
                      return Column(
                        children: [
                          Expanded(
                            child: DisplayTable(
                              columns: const [
                                DrugTableColumn.medicationName,
                                DrugTableColumn.category,
                                DrugTableColumn.route,
                                DrugTableColumn.price,
                              ],
                              drugData:
                                  //  [],
                                  state.drugs,
                              onRowTap: (drug) =>
                                  context.read<OrderCubit>().addDrug(drug),
                            ),
                          ),
                          PaginationBar(
                            currentPage: state.currentPage,
                            totalPages: context
                                .read<InventoryCubit>()
                                .totalPages,
                            totalCount: context
                                .read<InventoryCubit>()
                                .totalCount,
                            pageSize: InventoryCubit.pageSize,
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // const SizedBox(height: 80),
              // const Icon(Icons.add, size: 48, color: Colors.grey),
              // const SizedBox(height: 16),
              // Text('Add Medicine', style: AppTextStyles.titleMedium),
              // const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
