import 'package:flutter_bloc/flutter_bloc.dart';

import '../../drugs/repositories/drugs_repository.dart';
import '../models/order_item.dart';
import '../models/sale_item_model.dart';
import '../models/sale_model.dart';
import '../repositories/sales_repository.dart';
import 'sales_state.dart';

/// Manages the list of completed sales (the sales ledger).
///
/// Sales survive app restarts because [SalesRepository] persists transactions
/// directly to the local Drift SQLite database ([AppDatabase]).
///
/// Public API:
///   - [checkout]       – turn the active cart into a completed [SaleModel]
///   - [updateSearch]   – filter the history by reference / item name
///   - [filterByPayment]– filter the history by payment method (null == all)
///   - [clearHistory]   – wipe all persisted sales
class SalesCubit extends Cubit<SalesState> {
  SalesCubit({
    DrugsRepository? drugsRepository,
    SalesRepository? salesRepository,
  })  : _drugsRepository = drugsRepository,
        _salesRepository = salesRepository,
        super(const SalesState()) {
    if (_salesRepository != null) {
      _hydrate();
    }
  }

  final DrugsRepository? _drugsRepository;
  final SalesRepository? _salesRepository;

  // ── Hydration ──────────────────────────────────────────────────────────────

  /// Loads previously-saved sales from local Drift SQLite database on startup.
  Future<void> _hydrate() async {
    try {
      final sales = await _salesRepository!.getAllSales();
      if (sales.isNotEmpty) {
        emit(state.copyWith(sales: sales));
      } else {
        // If DB is brand new/empty, seed initial sales to populate UI tables
        final seedSales = _seedSales();
        for (final seed in seedSales) {
          final items = seed.items
              .map(
                (item) => OrderItem(
                  drug: itemToDrugPlaceholder(item),
                  quantity: item.quantity,
                ),
              )
              .toList();

          await _salesRepository.createSale(
            userName: seed.userName,
            paymentMethod: seed.paymentMethod,
            items: items,
          );
        }
        final reloaded = await _salesRepository.getAllSales();
        emit(state.copyWith(sales: reloaded));
      }
    } catch (_) {
      // Fallback gracefully on load error
      emit(state.copyWith(sales: _seedSales()));
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Records a completed sale from the current cart, persists it to Drift SQLite,
  /// and prepends it to history state.
  ///
  /// If a [DrugsRepository] was injected, this also deducts the sold quantities
  /// from inventory batches in FIFO order (nearest expiry first).
  ///
  /// Returns the created [SaleModel] so the caller can show a receipt dialog.
  Future<SaleModel> checkout({
    required List<OrderItem> cartItems,
    required PaymentMethod paymentMethod,
    String userName = 'D. Marwa',
  }) async {
    // Deduct stock first — if this throws we don't want a dangling sale entry.
    if (_drugsRepository != null && cartItems.isNotEmpty) {
      final deductions = <int, int>{};
      for (final item in cartItems) {
        final drugId = item.drug.id;
        if (drugId != null) {
          deductions.update(
            drugId,
            (existing) => existing + item.quantity,
            ifAbsent: () => item.quantity,
          );
        }
      }
      if (deductions.isNotEmpty) {
        await _drugsRepository.deductStockForSale(deductions);
      }
    }

    // Persist sale to Drift SQLite database
    final SaleModel sale;
    if (_salesRepository != null) {
      sale = await _salesRepository.createSale(
        userName: userName,
        paymentMethod: paymentMethod,
        items: cartItems,
      );
    } else {
      // Fallback in-memory if repo is omitted (e.g. tests)
      final items = cartItems
          .map(SaleItemModel.fromOrderItem)
          .toList(growable: false);
      final total = items.fold(0.0, (sum, item) => sum + item.lineTotal);
      sale = SaleModel(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        userName: userName,
        totalAmount: total,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
        items: items,
      );
    }

    // Update state (newest sale first)
    final updated = [sale, ...state.sales];
    emit(state.copyWith(sales: updated));
    return sale;
  }

  /// Updates the free-text search filter for the history table.
  void updateSearch(String query) => emit(state.copyWith(searchQuery: query));

  /// Sets the payment-method filter (pass null to show all).
  void filterByPayment(PaymentMethod? method) {
    if (method == null) {
      emit(state.copyWith(clearPaymentFilter: true));
    } else {
      emit(state.copyWith(paymentFilter: method));
    }
  }

  /// Wipes the entire sales ledger from local database.
  Future<void> clearHistory() async {
    emit(state.copyWith(sales: const []));
    await _salesRepository?.clearHistory();
  }

  // ── Seed helper ─────────────────────────────────────────────────────────────

  static dynamic itemToDrugPlaceholder(SaleItemModel item) {
    return _MockDrug(
      id: item.drugId,
      name: item.drugName,
      price: item.priceAtSale,
    );
  }

  static List<SaleModel> _seedSales() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      SaleModel(
        id: 1003,
        userName: 'D. Marwa',
        totalAmount: 138.0,
        paymentMethod: PaymentMethod.card,
        createdAt: today.add(const Duration(hours: 10, minutes: 42)),
        items: const [
          SaleItemModel(
            drugId: 1,
            drugName: '1 2 3 EXTRA 20 F.C.TABS.',
            quantity: 2,
            priceAtSale: 64.0,
          ),
          SaleItemModel(
            drugId: 2,
            drugName: '1 2 3 SUSP. 120 ML',
            quantity: 1,
            priceAtSale: 10.0,
          ),
        ],
      ),
      SaleModel(
        id: 1002,
        userName: 'D. Marwa',
        totalAmount: 74.0,
        paymentMethod: PaymentMethod.cash,
        createdAt: today.add(const Duration(hours: 9, minutes: 15)),
        items: const [
          SaleItemModel(
            drugId: 3,
            drugName: '2HC F.C.T 20 TABLETS',
            quantity: 2,
            priceAtSale: 37.0,
          ),
        ],
      ),
      SaleModel(
        id: 1001,
        userName: 'D. Marwa',
        totalAmount: 51.0,
        paymentMethod: PaymentMethod.insurance,
        createdAt: yesterday.add(const Duration(hours: 16, minutes: 30)),
        items: const [
          SaleItemModel(
            drugId: 4,
            drugName: '1 2 3 20 F.C.TABS.',
            quantity: 5,
            priceAtSale: 10.0,
          ),
          SaleItemModel(
            drugId: 2,
            drugName: '1 2 3 SUSP. 120 ML',
            quantity: 1,
            priceAtSale: 7.0,
          ),
        ],
      ),
    ];
  }
}

class _MockDrug {
  final int id;
  final String commercialNameEn;
  final double priceEGP;

  _MockDrug({
    required this.id,
    required String name,
    required double price,
  })  : commercialNameEn = name,
        priceEGP = price;
}
