import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/inventory/widgets/display_table.dart';

import '../drugs/repositories/drugs_repository.dart';
import 'inventory_cubit.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryCubit(
        drugRepository: RepositoryProvider.of<DrugsRepository>(context),
      ),
      child: Scaffold(body: SafeArea(child: _InventoryView())),
    );
  }
}

///to-do: implement the inventory view
///a3ml el bloc consumer & w map el data fe 3shan el drugData

class _InventoryView extends StatelessWidget {
  const _InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text("Inventory"),
        const SizedBox(height: 16),
        DisplayTable(
          columnNames: [
            "Medication name",
            "category",
            "Scientific Name",
            "stock level",
            "Route",
            "Price (EGP)",
          ],
          drugData: [],
        ),
      ],
    );
  }
}
