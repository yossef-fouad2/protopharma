import 'package:drift/drift.dart';
import 'timestamps.dart';

/// Drift database table for sales transactions, mirroring the backend
/// `sales` table in `backend/src/db/schema.ts`.
class SalesTable extends Table with TableTimestamps {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get totalAmount => real()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();

  /// Sync flag indicating whether this sale has been synchronized to the backend.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
