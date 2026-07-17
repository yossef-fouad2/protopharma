import 'package:drift/drift.dart';
import 'package:protopharma/data/tables/drug_table.dart';
import 'package:protopharma/data/tables/timestamps.dart';

/// Inventory batches for each drug.
///
/// A single drug can have multiple inventory rows (one per batch / lot),
/// mirroring the backend `inventory` table. Total stock for a drug is the
/// SUM of `quantity` across its inventory rows.
class InventoryTable extends Table with TableTimestamps {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key → DrugTable.id
  IntColumn get drugId => integer().references(DrugTable, #id)();

  IntColumn get quantity => integer().withDefault(const Constant(0))();
  TextColumn get batchNumber => text().withDefault(const Constant('N/A'))();

  /// Stored as ISO-8601 date string (yyyy-MM-dd) for simple sorting/filtering.
  TextColumn get expiryDate => text()();

  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0.0))();
}
