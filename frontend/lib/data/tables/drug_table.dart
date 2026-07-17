import 'package:drift/drift.dart';
import 'package:protopharma/data/tables/timestamps.dart';

/// Drug catalogue, mirroring the backend `drugs` table in
/// `backend/src/db/schema.ts`.
class DrugTable extends Table with TableTimestamps {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get commercialNameEn => text()();
  TextColumn get commercialNameAR =>
      text().withDefault(const Constant('N/A'))();
  TextColumn get scientificName => text().withDefault(const Constant('N/A'))();
  TextColumn get manufacturer => text().withDefault(const Constant('N/A'))();
  TextColumn get drugClass => text().withDefault(const Constant('N/A'))();
  TextColumn get route => text().withDefault(const Constant('N/A'))();
  RealColumn get priceEGP => real()();
}
