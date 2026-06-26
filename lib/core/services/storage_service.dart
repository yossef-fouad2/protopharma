import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';
import 'package:protopharma/features/drugs/services/load_drugs.dart';

late Box<DrugModel> drugBox;

Future<void> initHive() async {
  await Hive.initFlutter();
  try {
    Hive.registerAdapter(DrugModelAdapter());
  } catch (e) {
    debugPrint("Adapter already registered: $e");
  }
  drugBox = await Hive.openBox<DrugModel>('drugs');
}

Future<void> seedDrugDatabase() async {
  if (drugBox.isEmpty) {
    List<DrugModel> drugs = await loadDrugs();
    //adding the drugs

    drugBox.addAll(drugs);
    debugPrint("drugBox.length is ${drugBox.length}");
  } else {
    debugPrint("drugBox is not empty");
  }
}
