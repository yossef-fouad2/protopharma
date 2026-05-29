import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:protopharma/models/drug_model.dart';

Future<List<DrugModel>> loadDrugs() async {
  final String jsonDrugs = await rootBundle.loadString(
    'assets/data/egyptian-drugs.json',
  );
  final List<dynamic> list = json.decode(jsonDrugs);
  return list.map((e) => DrugModel.fromJson(e)).toList();
}
