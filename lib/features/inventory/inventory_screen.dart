import 'package:flutter/material.dart';
import 'package:protopharma/features/inventory/widgets/display_table.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
        ),
      ),
    );
  }
}
