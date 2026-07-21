import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/core/config/app_colors.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';
import 'package:protopharma/features/inventory/widgets/display_table.dart';
import 'package:protopharma/features/inventory/widgets/drug_detail_drawer.dart';
import 'package:protopharma/features/inventory/widgets/drug_form_dialog.dart';
import 'package:protopharma/features/inventory/widgets/pagination_bar.dart';
import 'package:protopharma/features/inventory/widgets/search_toolbar.dart';

import '../../core/config/app_text_styles.dart';
import '../drugs/repositories/drugs_repository.dart';
import 'inventory_cubit.dart';
import 'inventory_state.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InventoryCubit>(
      create: (_) =>
          InventoryCubit(drugRepository: context.read<DrugsRepository>()),
      child: const Scaffold(body: SafeArea(child: _InventoryView())),
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  /// Opens the sliding detail drawer for [drug], passing the existing cubit so
  /// edits reload the table underneath.
  void _openDetail(BuildContext context, DrugModel drug) {
    DrugDetailDrawer.show(
      context,
      drug: drug,
      cubit: context.read<InventoryCubit>(),
    );
  }

  /// Opens the create-medication form, then persists the new drug.
  Future<void> _addMedication(BuildContext context) async {
    final cubit = context.read<InventoryCubit>();
    final result = await DrugFormDialog.show(context);
    if (result == null) return;
    await cubit.addDrug(
      commercialNameEn: result.commercialNameEn,
      commercialNameAR: result.commercialNameAR,
      scientificName: result.scientificName,
      manufacturer: result.manufacturer,
      drugClass: result.drugClass,
      route: result.route,
      priceEGP: result.priceEGP,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        if (state is InventorySuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Inventory", style: AppTextStyles.h1),
                          Text(
                            "Manage medication, track stock, and edit prices",
                            style: AppTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                      ),
                      onPressed: () => _addMedication(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add medication'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const SearchToolbar(),

                const SizedBox(height: 16),

                // RepaintBoundary keeps this (fairly large) table on its own
                // layer, so it isn't re-rasterized while the detail drawer's
                // scrim fades in/out over it.
                Flexible(
                  child: RepaintBoundary(
                    child: DisplayTable(
                      columnNames: const [
                        "Medication name",
                        "Category",
                        "Scientific Name",
                        "Stock",
                        "Route",
                        "Price (EGP)",
                      ],
                      drugData: state.drugs,
                      onRowTap: (drug) => _openDetail(context, drug),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                PaginationBar(
                  currentPage: state.currentPage,
                  totalPages: context.read<InventoryCubit>().totalPages,
                  totalCount: context.read<InventoryCubit>().totalCount,
                  pageSize: InventoryCubit.pageSize,
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        }
        if (state is InventoryFailure) {
          return Text("Something went wrong");
        }
        if (state is InventoryInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        return SizedBox.shrink();
      },
    );
  }
}
