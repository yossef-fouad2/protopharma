import 'package:cloud_firestore/cloud_firestore.dart' hide Expression, Constant;
import 'package:drift/drift.dart' hide Query;
import 'package:protopharma/features/drugs/models/drug_model.dart';
import 'package:protopharma/features/home/models/inventory_alert.dart';
import '../../../data/app_database.dart';

class DrugsRepository {
  final FirebaseFirestore _firestore;
  final AppDatabase _db;
  // List of all loaded drugs across pages
  final List<DrugModel> drugs = [];

  // Pagination tracking variables
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;

  DrugsRepository({FirebaseFirestore? firestore, required AppDatabase db})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _db = db;

  // Getters to inspect the state from outside
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<List<DrugModel>> getLocalDrugs({
    int limit = 20,
    int offset = 0,
  }) async {
    // Query the table directly using the repository's local database instance (_db)
    final drugDataList =
        await (_db.select(_db.drugTable)
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
      ..where(_db.inventoryTable.drugId.isIn(ids))
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
      Expression<bool> condition = const Constant(true);

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
      ..groupBy([
        _db.inventoryTable.drugId,
      ], having: qtySum.isBiggerThanValue(0));
    return _db.drugTable.id.isInQuery(inStockIds);
  }

  /// Returns a sorted list of unique drug categories (drugClass column).
  Future<List<String>> getDistinctCategories() async {
    final query = _db.selectOnly(_db.drugTable, distinct: true)
      ..addColumns([_db.drugTable.drugClass])
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
      Expression<bool> condition = const Constant(true);

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
  String get _drugRollupSql => '''
    SELECT drug_id,
           SUM(quantity)     AS total_stock,
           MIN(expiry_date)  AS min_expiry
    FROM inventory_table
    GROUP BY drug_id
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

  /// Fetches a page of drugs from Firestore.
  ///
  /// Set [isRefresh] to true to start fetching from the first page again.
  Future<List<DrugModel>> getDrugs({
    int pageSize = 20,
    bool isRefresh = false,
    String? drugId,
  }) async {
    // If already loading, ignore duplicate calls
    if (_isLoading) return [];

    if (isRefresh) {
      _lastDocument = null;
      _hasMore = true;
      drugs.clear();
    }

    // If there is no more data, return empty list
    if (!_hasMore) return [];

    _isLoading = true;

    try {
      // 1. Start with the ordered query
      Query query = _firestore.collection('drugs').orderBy('commercialNameEn');

      // 2. Apply startAfterDocument cursor first (essential for fake_cloud_firestore sequence matching)
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      // 3. Apply limit last
      query = query.limit(pageSize);

      final querySnapshot = await query.get();

      // If we fetched fewer items than requested, we reached the end
      if (querySnapshot.docs.length < pageSize) {
        _hasMore = false;
      }

      // Save the last document as the cursor for the next page
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      // Map to models
      final newDrugs = querySnapshot.docs.map((doc) {
        return DrugModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      drugs.addAll(newDrugs);
      return newDrugs;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
