import 'package:flutter/material.dart';
import 'package:protopharma/models/drug_model.dart';
import 'package:protopharma/services/load_drugs.dart';
import 'package:protopharma/services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "search for a drug",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                print(drugBox.length);
                // List<DrugModel> drugs = await loadDrugs();
                //no need since we call it once the app runs
              },
              child: Text("load drugs"),
            ),
          ),
        ],
      ),
    );
  }
}
