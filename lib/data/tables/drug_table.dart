import 'package:drift/drift.dart';

class DrugTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get commercialNameEn => text()();
  TextColumn get commercialNameAR => text()();
  TextColumn get scientificName  => text()();
  TextColumn get manufacturer   => text()();
  TextColumn get drugClass   => text()();
  TextColumn get route    => text()();
  RealColumn get priceEGP    => real()();



}

