import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';

Future<int> _parseJsonCount(String jsonDrugs) async {
  return Isolate.run(() {
    final List<dynamic> list = json.decode(jsonDrugs);
    return list.length;
  });
}

Future<List<DrugModel>> _parseDrugs(String jsonDrugs) async {
  return Isolate.run(() {
    final List<dynamic> list = json.decode(jsonDrugs);
    return list.map((e) => DrugModel.fromJson(e)).toList();
  });
}

Future<void> insertAllDrugs(AppDatabase db) async {
  final count = await db.drugTable.count().getSingle();

  // Load the JSON string on the main isolate first (rootBundle needs ServicesBinding initialized on main thread)
  final String jsonDrugs = await rootBundle.loadString(
    'assets/data/egyptian-drugs.json',
  );

  // Decode the list length in a background isolate to keep main thread free
  final expectedCount = await _parseJsonCount(jsonDrugs);

  if (count == expectedCount) {
    debugPrint("Drugs already exist in the database and are fully seeded ($count)");
    return;
  }

  if (count > expectedCount) {
    debugPrint("Database count ($count) exceeds expected count ($expectedCount). Re-seeding database...");
    await db.delete(db.drugTable).go();
  }

  // Parse the full drug list using the loaded string
  final drugs = await _parseDrugs(jsonDrugs);
  final currentCount = await db.drugTable.count().getSingle();

  debugPrint("Seeding database: current count is $currentCount, expected is $expectedCount.");

  // Resume seeding from the current database count to avoid re-inserting already seeded items
  const chunkSize = 1000;
  for (int i = currentCount; i < drugs.length; i += chunkSize) {
    final end = (i + chunkSize < drugs.length) ? i + chunkSize : drugs.length;
    final chunk = drugs.sublist(i, end);

    await db.batch((batch) {
      batch.insertAll(
        db.drugTable,
        chunk.map(
          (drug) => DrugTableCompanion.insert(
            commercialNameEn: drug.commercialNameEn,
            commercialNameAR: drug.commercialNameAR,
            scientificName: drug.scientificName,
            manufacturer: drug.manufacturer,
            drugClass: drug.drugClass,
            route: drug.route,
            priceEGP: drug.priceEGP,
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });

    // Yield control back to the Flutter main isolate event loop to keep the UI perfectly smooth
    await Future.delayed(const Duration(milliseconds: 3));
  }

  final finalCount = await db.drugTable.count().getSingle();
  debugPrint("Database seeding complete. Final count: $finalCount");
}
