import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_theme.dart';
import 'package:protopharma/core/services/storage_service.dart';
import 'package:protopharma/core/services/storage_service.dart' as hive_service;
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // final drugsRepo = DrugsRepository();
  // late final drugs = drugsRepo.getDrugs();
  final drugBox = hive_service.drugBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome to protopharma',
          style: AppTextStyles.cairoBold.copyWith(fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Search for a drug",
                  style: AppTextStyles.outfitMedium.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    // var drugsRepo = DrugsRepository();
                    // var drugs = await drugsRepo.getDrugs();
                    final list = drugBox.values.toList();
                    debugPrint("Number of drugs: ${list.length}");
                    debugPrint(
                      "First 20 drugs: ${list.take(20).map((e) => e.commercialNameEn).toList()}",
                    );
                  },
                  child: Text("Load Drugs", style: AppTextStyles.poppinsMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
