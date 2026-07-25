import 'package:drift/drift.dart';
import 'timestamps.dart';
import 'sales_table.dart';
import 'drug_table.dart';

/// Drift database table for sale items, mirroring the backend
/// `sale_items` table in `backend/src/db/schema.ts`.
class SaleItemsTable extends Table with TableTimestamps {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(SalesTable, #id)();
  IntColumn get drugId => integer().references(DrugTable, #id)();
  IntColumn get quantity => integer()();
  RealColumn get priceAtSale => real()();

  /// Sync flag indicating whether this sale item has been synchronized to the backend.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
