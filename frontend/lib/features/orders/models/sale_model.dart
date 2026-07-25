import 'package:equatable/equatable.dart';

import 'sale_item_model.dart';

/// The supported ways a customer can pay for a sale.
///
/// Kept as an enum (rather than raw strings) so the UI can filter/label them
/// consistently. [wireValue] is the string persisted for a future backend.
enum PaymentMethod {
  cash,
  card,
  insurance;

  /// Human-friendly label used in chips, receipts, and the history table.
  String get label => switch (this) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.card => 'Card',
    PaymentMethod.insurance => 'Insurance',
  };

  /// Lowercase value matching the Drizzle schema ('cash' | 'card' | 'insurance').
  String get wireValue => name;
}

/// A completed sale (one checkout) with its snapshot of line items.
///
/// Fields mirror the future `sales` DB table so this can be swapped for a real
/// repository later with minimal churn.
class SaleModel extends Equatable {
  const SaleModel({
    required this.id,
    required this.userName,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  final int id;

  /// Cashier / pharmacist who rang up the sale.
  final String userName;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final List<SaleItemModel> items;

  /// Total number of units sold across all lines.
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Display reference like `#1001`.
  String get reference => '#$id';

  // ── JSON persistence ─────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod.wireValue,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((i) => i.toJson()).toList(),
  };

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: (json['id'] as num).toInt(),
      userName: json['userName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (m) => m.wireValue == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userName,
    totalAmount,
    paymentMethod,
    createdAt,
    items,
  ];
}
