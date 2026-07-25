import 'package:drift/drift.dart';
import 'package:protopharma/features/drugs/models/batch_model.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';
import 'package:protopharma/features/home/models/inventory_alert.dart';
import '../../../data/app_database.dart';

class DrugsRepository {
  final AppDatabase _db;

  DrugsRepository({required AppDatabase db}) : _db = db;

  Future<List<DrugModel>> getLocalDrugs({
    int limit = 20,
    int offset = 0,
  }) async {
    // Query the table directly using the repository's local database instance (_db)
    final drugDataList =
        await (_db.select(_db.drugTable)
              ..where((t) => t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.commercialNameEn)])
              ..limit(limit, offset: offset))
            .get();
    // Map to models, then attach stock info from the inventory table.
    final models = drugDataList
        .map(
          (e) => DrugModel(
            id: e.id,
            commercialNameEn: e.commercialNameEn,
            commercialNameAR: e.commercialNameAR,
            scientificName: e.scientificName,
            manufacturer: e.manufacturer,
            drugClass: e.drugClass,
            route: e.route,
            priceEGP: e.priceEGP,
          ),
        )
        .toList();
    return _attachStock(models);
  }

  /// Enriches [drugs] with `totalStock` and `nearestExpiry` computed from the
  /// inventory batches table in a single grouped query.
  Future<List<DrugModel>> _attachStock(List<DrugModel> drugs) async {
    if (drugs.isEmpty) return drugs;

    final ids = drugs.map((d) => d.id).whereType<int>().toList();
    if (ids.isEmpty) return drugs;

    final qtySum = _db.inventoryTable.quantity.sum();
    final minExpiry = _db.inventoryTable.expiryDate.min();

    final query = _db.selectOnly(_db.inventoryTable)
      ..addColumns([_db.inventoryTable.drugId, qtySum, minExpiry])
      ..where(
        _db.inventoryTable.drugId.isIn(ids) &
            _db.inventoryTable.deletedAt.isNull(),
      )
      ..groupBy([_db.inventoryTable.drugId]);

    final rows = await query.get();

    final stockByDrug = <int, int>{};
    final expiryByDrug = <int, String?>{};
    for (final row in rows) {
      final drugId = row.read(_db.inventoryTable.drugId);
      if (drugId == null) continue;
      stockByDrug[drugId] = row.read(qtySum) ?? 0;
      expiryByDrug[drugId] = row.read(minExpiry);
    }

    return drugs
        .map(
          (d) => d.copyWith(
            totalStock: d.id == null ? 0 : (stockByDrug[d.id] ?? 0),
            nearestExpiry: d.id == null ? null : expiryByDrug[d.id],
          ),
        )
        .toList();
  }

  /// Fetches drugs filtered by an optional [query] (name search) and/or
  /// [category] (exact drug-class match), with pagination.
  Future<List<DrugModel>> searchLocalDrugs({
    String? query,
    String? category,
    bool inStockOnly = false,
    int limit = 20,
    int offset = 0,
  }) async {
    final select = _db.select(_db.drugTable);

    // Apply filters
    select.where((t) {
      Expression<bool> condition = t.deletedAt.isNull();

      if (query != null && query.trim().isNotEmpty) {
        final matchPattern = '%${query.trim()}%';
        condition =
            condition &
            (t.commercialNameEn.like(matchPattern) |
                t.commercialNameAR.like(matchPattern));
      }
      if (category != null && category.trim().isNotEmpty) {
        condition = condition & t.drugClass.equals(category.trim());
      }
      // Only include drugs that currently have stock in at least one batch.
      if (inStockOnly) {
        condition = condition & _inStockDrugIdExpr();
      }

      return condition;
    });

    // Order & paginate
    select
      ..orderBy([(t) => OrderingTerm.asc(t.commercialNameEn)])
      ..limit(limit, offset: offset);

    final rows = await select.get();

    final models = rows
        .map(
          (e) => DrugModel(
            id: e.id,
            commercialNameEn: e.commercialNameEn,
            commercialNameAR: e.commercialNameAR,
            scientificName: e.scientificName,
            manufacturer: e.manufacturer,
            drugClass: e.drugClass,
            route: e.route,
            priceEGP: e.priceEGP,
          ),
        )
        .toList();
    return _attachStock(models);
  }

  /// Subquery expression: drug has total stock > 0 across its inventory batches.
  Expression<bool> _inStockDrugIdExpr() {
    final qtySum = _db.inventoryTable.quantity.sum();
    final inStockIds = _db.selectOnly(_db.inventoryTable)
      ..addColumns([_db.inventoryTable.drugId])
      ..where(_db.inventoryTable.deletedAt.isNull())
      ..groupBy([
        _db.inventoryTable.drugId,
      ], having: qtySum.isBiggerThanValue(0));
    return _db.drugTable.id.isInQuery(inStockIds);
  }

  /// Returns a sorted list of unique drug categories (drugClass column).
  Future<List<String>> getDistinctCategories() async {
    final query = _db.selectOnly(_db.drugTable, distinct: true)
      ..addColumns([_db.drugTable.drugClass])
      ..where(_db.drugTable.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.drugTable.drugClass)]);

    final rows = await query.get();
    return rows
        .map((row) => row.read(_db.drugTable.drugClass))
        .where((val) => val != null && val.trim().isNotEmpty)
        .cast<String>()
        .toList();
  }

  /// Returns the total count of drugs matching the given filters.
  Future<int> getFilteredDrugCount({
    String? query,
    String? category,
    bool inStockOnly = false,
  }) async {
    final countExp = _db.drugTable.id.count();
    final q = _db.selectOnly(_db.drugTable)..addColumns([countExp]);

    q.where(() {
      Expression<bool> condition = _db.drugTable.deletedAt.isNull();

      if (query != null && query.trim().isNotEmpty) {
        final matchPattern = '%${query.trim()}%';
        condition =
            condition &
            (_db.drugTable.commercialNameEn.like(matchPattern) |
                _db.drugTable.commercialNameAR.like(matchPattern));
      }
      if (category != null && category.trim().isNotEmpty) {
        condition = condition & _db.drugTable.drugClass.equals(category.trim());
      }
      if (inStockOnly) {
        condition = condition & _inStockDrugIdExpr();
      }

      return condition;
    }());

    final result = await q.getSingle();
    return result.read(countExp)!;
  }

  Future<int> getTotalDrugCount() async {
    final countExp = _db.drugTable.id.count();
    final query = _db.selectOnly(_db.drugTable)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp)!;
  }

  /// Emits the live list of unique, active drug categories (drugClass column).
  ///
  /// Reactive so the category filter dropdown updates automatically when a
  /// drug's class is created, edited, or soft-deleted.
  Stream<List<String>> watchDistinctCategories() {
    final query = _db.selectOnly(_db.drugTable, distinct: true)
      ..addColumns([_db.drugTable.drugClass])
      ..where(_db.drugTable.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.drugTable.drugClass)]);

    return query.watch().map(
      (rows) => rows
          .map((row) => row.read(_db.drugTable.drugClass))
          .where((val) => val != null && val.trim().isNotEmpty)
          .cast<String>()
          .toList(),
    );
  }

  // ── Drug catalog CRUD ────────────────────────────────────────────────────

  /// Inserts a new drug into the catalog and returns its generated id.
  Future<int> createDrug({
    required String commercialNameEn,
    String commercialNameAR = 'N/A',
    String scientificName = 'N/A',
    String manufacturer = 'N/A',
    String drugClass = 'N/A',
    String route = 'N/A',
    required double priceEGP,
  }) {
    return _db
        .into(_db.drugTable)
        .insert(
          DrugTableCompanion.insert(
            commercialNameEn: commercialNameEn,
            commercialNameAR: Value(commercialNameAR),
            scientificName: Value(scientificName),
            manufacturer: Value(manufacturer),
            drugClass: Value(drugClass),
            route: Value(route),
            priceEGP: priceEGP,
          ),
        );
  }

  /// Updates the catalog metadata for an existing drug.
  ///
  /// Bumps `updatedAt` since the [TableTimestamps] client default only fires
  /// on insert.
  Future<void> updateDrug({
    required int id,
    required String commercialNameEn,
    required String commercialNameAR,
    required String scientificName,
    required String manufacturer,
    required String drugClass,
    required String route,
    required double priceEGP,
  }) {
    return (_db.update(_db.drugTable)..where((t) => t.id.equals(id))).write(
      DrugTableCompanion(
        commercialNameEn: Value(commercialNameEn),
        commercialNameAR: Value(commercialNameAR),
        scientificName: Value(scientificName),
        manufacturer: Value(manufacturer),
        drugClass: Value(drugClass),
        route: Value(route),
        priceEGP: Value(priceEGP),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-deletes a drug and cascades the soft-delete to all of its inventory
  /// batches in a single transaction.
  ///
  /// Setting `deletedAt` on both sides keeps stock rollups and dashboard alerts
  /// consistent: a deleted drug's remaining batches never contribute to totals.
  Future<void> softDeleteDrug(int id) {
    final now = DateTime.now();
    return _db.transaction(() async {
      await (_db.update(_db.drugTable)..where((t) => t.id.equals(id))).write(
        DrugTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      await (_db.update(
        _db.inventoryTable,
      )..where((t) => t.drugId.equals(id) & t.deletedAt.isNull())).write(
        InventoryTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  // ── Inventory batch CRUD ─────────────────────────────────────────────────

  /// Emits the live list of active (non-deleted) batches for a drug, ordered by
  /// soonest expiry first. Powers the batch list inside the detail drawer.
  Stream<List<BatchModel>> watchBatchesForDrug(int drugId) {
    final query = _db.select(_db.inventoryTable)
      ..where((t) => t.drugId.equals(drugId) & t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]);

    return query.watch().map(
      (rows) => rows
          .map(
            (e) => BatchModel(
              id: e.id,
              drugId: e.drugId,
              quantity: e.quantity,
              batchNumber: e.batchNumber,
              expiryDate: e.expiryDate,
              purchasePrice: e.purchasePrice,
              sellingPrice: e.sellingPrice,
            ),
          )
          .toList(),
    );
  }

  /// Adds a new inventory batch (lot) for a drug and returns its generated id.
  Future<int> addBatch({
    required int drugId,
    required int quantity,
    required String batchNumber,
    required String expiryDate,
    required double purchasePrice,
    required double sellingPrice,
  }) {
    return _db
        .into(_db.inventoryTable)
        .insert(
          InventoryTableCompanion.insert(
            drugId: drugId,
            quantity: Value(quantity),
            batchNumber: Value(batchNumber),
            expiryDate: expiryDate,
            purchasePrice: Value(purchasePrice),
            sellingPrice: Value(sellingPrice),
          ),
        );
  }

  /// Updates an existing batch and bumps `updatedAt`.
  Future<void> updateBatch({
    required int id,
    required int quantity,
    required String batchNumber,
    required String expiryDate,
    required double purchasePrice,
    required double sellingPrice,
  }) {
    return (_db.update(
      _db.inventoryTable,
    )..where((t) => t.id.equals(id))).write(
      InventoryTableCompanion(
        quantity: Value(quantity),
        batchNumber: Value(batchNumber),
        expiryDate: Value(expiryDate),
        purchasePrice: Value(purchasePrice),
        sellingPrice: Value(sellingPrice),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Sales stock consumption ─────────────────────────────────────────────
  //
  // When a checkout completes we need to walk the inventory batches for each
  // sold drug and decrement their `quantity` in FIFO order (nearest expiry
  // first) so older lots leave the shelf before newer ones.
  //
  // The whole operation runs in a single transaction so a partial failure
  // never leaves the ledger in an inconsistent state.

  /// Deducts [drugIdToQuantity] units from inventory in FIFO order.
  ///
  /// Returns a map of `drugId -> actually deducted quantity` so callers can
  /// warn the user when the request exceeded the available stock. Batches
  /// that reach zero are left in the table (their qty simply becomes 0) so
  /// history and audit trails stay intact.
  Future<Map<int, int>> deductStockForSale(
    Map<int, int> drugIdToQuantity,
  ) async {
    if (drugIdToQuantity.isEmpty) return const {};
    final deducted = <int, int>{};

    await _db.transaction(() async {
      for (final entry in drugIdToQuantity.entries) {
        final drugId = entry.key;
        var remaining = entry.value;
        if (remaining <= 0) continue;

        // Load all active batches ordered by soonest expiry (FIFO).
        final batches =
            await (_db.select(_db.inventoryTable)
                  ..where((t) => t.drugId.equals(drugId) & t.deletedAt.isNull())
                  ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
                .get();

        for (final batch in batches) {
          if (remaining <= 0) break;
          if (batch.quantity <= 0) continue;

          final take = batch.quantity < remaining ? batch.quantity : remaining;
          final newQty = batch.quantity - take;

          await (_db.update(
            _db.inventoryTable,
          )..where((t) => t.id.equals(batch.id))).write(
            InventoryTableCompanion(
              quantity: Value(newQty),
              updatedAt: Value(DateTime.now()),
            ),
          );

          remaining -= take;
        }

        deducted[drugId] = entry.value - remaining;
      }
    });

    return deducted;
  }

  /// Soft-deletes a single batch. The parent drug stays active.
  Future<void> deleteBatch(int id) {
    final now = DateTime.now();
    return (_db.update(
      _db.inventoryTable,
    )..where((t) => t.id.equals(id))).write(
      InventoryTableCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  // ── Critical alerts (dashboard) ─────────────────────────────────────────
  //
  // Alerts are derived from the inventory table entirely in SQL so the
  // dashboard stays fast even with a large catalogue:
  //   • counts are watched reactively (one lightweight aggregate query)
  //   • the actual alert rows are fetched one page at a time on demand
  //
  // A drug is bucketed by priority: out-of-stock, then low-stock, then
  // expiring-soon (so an item is never counted in two buckets).

  /// Number of days ahead within which a batch is considered "expiring soon".
  static const int expiringWithinDays = 30;

  /// Common per-drug rollup subquery: total stock and soonest expiry per drug.
  ///
  /// Excludes soft-deleted batches and only rolls up batches whose parent drug
  /// is still active, so deleted drugs/batches never feed the dashboard alerts.
  String get _drugRollupSql => '''
    SELECT i.drug_id        AS drug_id,
           SUM(i.quantity)  AS total_stock,
           MIN(i.expiry_date) AS min_expiry
    FROM inventory_table i
    JOIN drug_table d ON d.id = i.drug_id AND d.deleted_at IS NULL
    WHERE i.deleted_at IS NULL
    GROUP BY i.drug_id
  ''';

  /// Today's date as an ISO-8601 string (yyyy-MM-dd).
  String get _today {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// The latest expiry date (inclusive) that still counts as "expiring soon".
  String get _expiryCutoff {
    final cutoff = DateTime.now().add(const Duration(days: expiringWithinDays));
    return '${cutoff.year.toString().padLeft(4, '0')}-'
        '${cutoff.month.toString().padLeft(2, '0')}-'
        '${cutoff.day.toString().padLeft(2, '0')}';
  }

  /// Watches the inventory table and emits live per-category alert counts.
  ///
  /// This is a single aggregate query, so it re-runs cheaply whenever the
  /// inventory table changes — no per-drug work happens in Dart.
  Stream<AlertCounts> watchAlertCounts() {
    final threshold = DrugModel.lowStockThreshold;

    final query = _db.customSelect(
      '''
      SELECT
        COALESCE(SUM(CASE WHEN total_stock <= 0 THEN 1 ELSE 0 END), 0)
          AS out_of_stock,
        COALESCE(SUM(CASE WHEN total_stock > 0
                           AND total_stock <= ?1 THEN 1 ELSE 0 END), 0)
          AS low_stock,
        COALESCE(SUM(CASE WHEN total_stock > ?1
                           AND min_expiry IS NOT NULL
                           AND min_expiry <= ?2 THEN 1 ELSE 0 END), 0)
          AS expiring
      FROM ( $_drugRollupSql )
      ''',
      variables: [
        Variable.withInt(threshold),
        Variable.withString(_expiryCutoff),
      ],
      readsFrom: {_db.inventoryTable},
    );

    return query.watchSingle().map((row) {
      return AlertCounts(
        outOfStock: row.read<int>('out_of_stock'),
        lowStock: row.read<int>('low_stock'),
        expiring: row.read<int>('expiring'),
      );
    });
  }

  /// Fetches a single page of alerts for the given [type].
  ///
  /// Filtering, ordering, and pagination all happen in SQL, so only [limit]
  /// rows are ever materialised regardless of catalogue size.
  Future<List<InventoryAlert>> fetchAlerts({
    required AlertType type,
    required int limit,
    required int offset,
  }) async {
    final threshold = DrugModel.lowStockThreshold;

    // Each category has its own WHERE clause over the per-drug rollup.
    final where = switch (type) {
      AlertType.outOfStock => 'r.total_stock <= 0',
      AlertType.lowStock => 'r.total_stock > 0 AND r.total_stock <= ?1',
      AlertType.expiringSoon =>
        'r.total_stock > ?1 AND r.min_expiry IS NOT NULL AND r.min_expiry <= ?2',
    };

    final query = _db.customSelect(
      '''
      SELECT d.id            AS drug_id,
             d.commercial_name_en AS drug_name,
             r.total_stock   AS total_stock,
             r.min_expiry    AS min_expiry
      FROM ( $_drugRollupSql ) AS r
      JOIN drug_table d ON d.id = r.drug_id
      WHERE $where
      ORDER BY d.commercial_name_en
      LIMIT ?3 OFFSET ?4
      ''',
      variables: [
        Variable.withInt(threshold),
        Variable.withString(_expiryCutoff),
        Variable.withInt(limit),
        Variable.withInt(offset),
      ],
      readsFrom: {_db.inventoryTable, _db.drugTable},
    );

    final rows = await query.get();
    return rows.map((row) {
      final drugId = row.read<int>('drug_id');
      final drugName = row.read<String>('drug_name');
      final stock = row.read<int>('total_stock');
      final minExpiry = row.read<String?>('min_expiry');
      return _buildAlert(
        type: type,
        drugId: drugId,
        drugName: drugName,
        stock: stock,
        nearestExpiry: minExpiry,
      );
    }).toList();
  }

  /// Builds the UI-facing [InventoryAlert] for a drug already known to belong
  /// to [type].
  InventoryAlert _buildAlert({
    required AlertType type,
    required int drugId,
    required String drugName,
    required int stock,
    required String? nearestExpiry,
  }) {
    switch (type) {
      case AlertType.outOfStock:
        return InventoryAlert(
          drugId: drugId,
          drugName: drugName,
          type: type,
          severity: AlertSeverity.critical,
          title: 'Out of Stock: $drugName',
          description: 'No units remaining. Reorder to avoid disruption.',
          actionLabel: 'Reorder Now',
        );
      case AlertType.lowStock:
        return InventoryAlert(
          drugId: drugId,
          drugName: drugName,
          type: type,
          severity: AlertSeverity.critical,
          title: 'Low Stock: $drugName',
          description:
              'Only $stock left. Below safety threshold of '
              '${DrugModel.lowStockThreshold}.',
          actionLabel: 'Reorder Now',
        );
      case AlertType.expiringSoon:
        final days = _daysUntil(nearestExpiry);
        return InventoryAlert(
          drugId: drugId,
          drugName: drugName,
          type: type,
          severity: AlertSeverity.warning,
          title: 'Expiring Soon: $drugName',
          description: (days == null || days <= 0)
              ? 'A batch has already expired. Remove it from shelves.'
              : 'A batch expires in $days day${days == 1 ? '' : 's'}.',
          actionLabel: 'Review Batch',
        );
    }
  }

  /// Days from today until [isoDate] (yyyy-MM-dd). Null if unparsable.
  /// Negative when the date is already in the past.
  int? _daysUntil(String? isoDate) {
    if (isoDate == null) return null;
    final date = DateTime.tryParse(isoDate);
    if (date == null) return null;

    final today = DateTime.tryParse(_today)!;
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }
}
