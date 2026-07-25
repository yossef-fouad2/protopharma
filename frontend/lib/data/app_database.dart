import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:protopharma/data/tables/drug_table.dart';
import 'package:protopharma/data/tables/inventory_table.dart';
import 'package:protopharma/data/tables/sales_table.dart';
import 'package:protopharma/data/tables/sale_items_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DrugTable, InventoryTable, SalesTable, SaleItemsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // v1 → v2: introduce the inventory batches table.
      if (from < 2) {
        await m.createTable(inventoryTable);
      }
      // v2 → v3: add shared timestamp columns (created/updated/deleted) to
      // both tables to mirror the backend `timestamps` block.
      if (from < 3) {
        final nowEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        for (final table in const ['drug_table', 'inventory_table']) {
          await customStatement(
            'ALTER TABLE $table ADD COLUMN created_at '
            'INTEGER NOT NULL DEFAULT $nowEpoch',
          );
          await customStatement(
            'ALTER TABLE $table ADD COLUMN updated_at '
            'INTEGER NOT NULL DEFAULT $nowEpoch',
          );
          await customStatement(
            'ALTER TABLE $table ADD COLUMN deleted_at INTEGER',
          );
        }
      }
      // v3 → v4: introduce sales and sale_items tables for POS sales history.
      if (from < 4) {
        await m.createTable(salesTable);
        await m.createTable(saleItemsTable);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'protopharma_database.db'));
    return NativeDatabase.createBackgroundConnection(file);
  });
}
