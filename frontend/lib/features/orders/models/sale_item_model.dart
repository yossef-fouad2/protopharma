import 'package:equatable/equatable.dart';

import 'order_item.dart';

/// A single line inside a completed [SaleModel].
///
/// This is a *snapshot* taken at checkout time — the drug name and unit price
/// are copied in so the historical record never changes even if the drug is
/// later edited or deleted. Fields mirror the future `sale_items` DB table for
/// seamless backend integration.
class SaleItemModel extends Equatable {
  const SaleItemModel({
    required this.drugId,
    required this.drugName,
    required this.quantity,
    required this.priceAtSale,
  });

  final int drugId;
  final String drugName;
  final int quantity;

  /// Unit price captured at the moment of sale.
  final double priceAtSale;

  /// Total price for this line (unit price × quantity).
  double get lineTotal => quantity * priceAtSale;

  /// Builds a snapshot line from a live cart [OrderItem].
  factory SaleItemModel.fromOrderItem(OrderItem item) {
    return SaleItemModel(
      drugId: item.drug.id ?? 0,
      drugName: item.drug.commercialNameEn,
      quantity: item.quantity,
      priceAtSale: item.drug.priceEGP,
    );
  }

  // ── JSON persistence ─────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'drugId': drugId,
    'drugName': drugName,
    'quantity': quantity,
    'priceAtSale': priceAtSale,
  };

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      drugId: (json['drugId'] as num).toInt(),
      drugName: json['drugName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      priceAtSale: (json['priceAtSale'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [drugId, drugName, quantity, priceAtSale];
}
