import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:protopharma/data/app_database.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';

Future<List<DrugModel>> loadDrugs() async {
  final String jsonDrugs = await rootBundle.loadString(
    'assets/data/egyptian-drugs.json',
  );
  final List<dynamic> list = json.decode(jsonDrugs);
  return list.map((e) => DrugModel.fromJson(e)).toList();
}

Future<void> insertAllDrugs(AppDatabase db) async {
  final count = await db.drugTable.count().getSingle();

  if (count > 0) {
    debugPrint("Drugs already exist in the database");
    return;
  }

  final drugs = await loadDrugs();

  await db.batch((batch) {
    batch.insertAll(
      db.drugTable,
      drugs.map(
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
}
