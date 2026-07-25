import 'package:drift/drift.dart';
import '../../../data/app_database.dart';
import '../models/order_item.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';

/// Repository responsible for persisting and retrieving sales transactions
/// using the local Drift SQLite database ([AppDatabase]).
class SalesRepository {
  final AppDatabase _db;

  SalesRepository({required AppDatabase db}) : _db = db;

  /// Retrieves all completed sales ordered by creation date (newest first),
  /// with their line items fully hydrated.
  Future<List<SaleModel>> getAllSales() async {
    final salesData = await (_db.select(_db.salesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    final List<SaleModel> result = [];

    for (final sale in salesData) {
      // Query items for this sale
      final itemsData = await (_db.select(_db.saleItemsTable)
            ..where((t) => t.saleId.equals(sale.id)))
          .get();

      final List<SaleItemModel> itemModels = [];
      for (final item in itemsData) {
        // Look up drug name snapshot from drugTable or fallback
        final drug = await (_db.select(_db.drugTable)
              ..where((t) => t.id.equals(item.drugId)))
            .getSingleOrNull();

        final drugName = drug?.commercialNameEn ?? 'Drug #${item.drugId}';

        itemModels.add(
          SaleItemModel(
            drugId: item.drugId,
            drugName: drugName,
            quantity: item.quantity,
            priceAtSale: item.priceAtSale,
          ),
        );
      }

      final paymentMethod = PaymentMethod.values.firstWhere(
        (m) => m.wireValue == sale.paymentMethod,
        orElse: () => PaymentMethod.cash,
      );

      result.add(
        SaleModel(
          id: sale.id,
          userName: 'Cashier #${sale.userId}',
          totalAmount: sale.totalAmount,
          paymentMethod: paymentMethod,
          createdAt: sale.createdAt,
          items: itemModels,
        ),
      );
    }

    return result;
  }

  /// Atomically inserts a new sale and its line items into the local SQLite database.
  Future<SaleModel> createSale({
    int userId = 1,
    required String userName,
    required PaymentMethod paymentMethod,
    required List<OrderItem> items,
  }) async {
    final totalAmount = items.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.drug.priceEGP),
    );

    return await _db.transaction(() async {
      final now = DateTime.now();

      // Insert sale record
      final saleId = await _db.into(_db.salesTable).insert(
        SalesTableCompanion.insert(
          userId: userId,
          totalAmount: totalAmount,
          paymentMethod: Value(paymentMethod.wireValue),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final List<SaleItemModel> itemSnapshots = [];

      // Insert line items
      for (final item in items) {
        final drugId = item.drug.id ?? 0;
        await _db.into(_db.saleItemsTable).insert(
          SaleItemsTableCompanion.insert(
            saleId: saleId,
            drugId: drugId,
            quantity: item.quantity,
            priceAtSale: item.drug.priceEGP,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

        itemSnapshots.add(
          SaleItemModel(
            drugId: drugId,
            drugName: item.drug.commercialNameEn,
            quantity: item.quantity,
            priceAtSale: item.drug.priceEGP,
          ),
        );
      }

      return SaleModel(
        id: saleId,
        userName: userName,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        createdAt: now,
        items: itemSnapshots,
      );
    });
  }

  /// Clears all local sales history (for local testing/resetting).
  Future<void> clearHistory() async {
    await _db.delete(_db.saleItemsTable).go();
    await _db.delete(_db.salesTable).go();
  }
}
