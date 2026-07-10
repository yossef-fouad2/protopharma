import 'package:flutter/material.dart';
import 'package:protopharma/core/config/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // final drugsRepo = DrugsRepository();
  // late final drugs = drugsRepo.getDrugs();
  // final drugBox = hive_service.drugBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
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
                    //to-do: Seed the database with drugs
                    // var drugs = await insertAllDrugs(db);
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
