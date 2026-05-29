import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:protopharma/models/drug_model.dart';
import 'package:protopharma/services/load_drugs.dart';

late Box<DrugModel> drugBox;

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DrugModelAdapter());
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
