import 'package:flutter/material.dart';
import 'package:protopharma/config/app_theme.dart';
import 'package:protopharma/models/drugs_repositry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    var drugsRepo = DrugsRepository();
                    var drugs = await drugsRepo.getDrugs();
                    debugPrint("Number of drugs: ${drugs.length}");
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
