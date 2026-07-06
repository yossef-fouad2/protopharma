import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/inventory/widgets/display_table.dart';
import 'package:protopharma/features/inventory/widgets/pagination_bar.dart';

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

///to-do: implement the inventory view
///a3ml el bloc consumer & w map el data fe 3shan el drugData

class _InventoryView extends StatelessWidget {
  const _InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        if (state is InventorySuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text("Inventory", style: AppTextStyles.h1),
                Text(
                  "Manage medication, track stock, and edit prices",
                  style: AppTextStyles.bodyLarge,
                ),

                const SizedBox(height: 16),

                Flexible(
                  child: DisplayTable(
                    columnNames: const [
                      "Medication name",
                      "Category",
                      "Scientific Name",
                      "Manufacturer",
                      "Route",
                      "Price (EGP)",
                    ],
                    drugData: state.drugs,
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
