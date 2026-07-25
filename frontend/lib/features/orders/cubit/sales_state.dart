import 'package:equatable/equatable.dart';

import '../models/sale_model.dart';

/// Immutable state for the completed-sales history (in-memory for now).
///
/// [sales] holds every completed sale, newest first. [searchQuery] and
/// [paymentFilter] are the active filters applied by the Order History view;
/// [filteredSales] applies them so widgets don't re-implement the logic.
class SalesState extends Equatable {
  const SalesState({
    this.sales = const [],
    this.searchQuery = '',
    this.paymentFilter,
  });

  /// All completed sales, ordered newest → oldest.
  final List<SaleModel> sales;

  /// Free-text search over the sale reference and item names.
  final String searchQuery;

  /// When set, only sales paid with this method are shown. Null == "All".
  final PaymentMethod? paymentFilter;

  // ── Derived: dashboard metrics ────────────────────────────────────────────

  /// Sum of every completed sale's total.
  double get totalRevenue =>
      sales.fold(0.0, (sum, sale) => sum + sale.totalAmount);

  /// Number of completed sales.
  int get totalSalesCount => sales.length;

  /// Mean value per sale (0 when there are none).
  double get averageOrderValue =>
      sales.isEmpty ? 0.0 : totalRevenue / sales.length;

  // ── Derived: filtered list for the history table ──────────────────────────

  /// [sales] with [searchQuery] and [paymentFilter] applied.
  List<SaleModel> get filteredSales {
    final query = searchQuery.trim().toLowerCase();
    return sales.where((sale) {
      if (paymentFilter != null && sale.paymentMethod != paymentFilter) {
        return false;
      }
      if (query.isEmpty) return true;
      final matchesRef = sale.reference.toLowerCase().contains(query);
      final matchesItem = sale.items.any(
        (item) => item.drugName.toLowerCase().contains(query),
      );
      return matchesRef || matchesItem;
    }).toList();
  }

  SalesState copyWith({
    List<SaleModel>? sales,
    String? searchQuery,
    PaymentMethod? paymentFilter,
    bool clearPaymentFilter = false,
  }) {
    return SalesState(
      sales: sales ?? this.sales,
      searchQuery: searchQuery ?? this.searchQuery,
      paymentFilter: clearPaymentFilter
          ? null
          : (paymentFilter ?? this.paymentFilter),
    );
  }

  @override
  List<Object?> get props => [sales, searchQuery, paymentFilter];
}
