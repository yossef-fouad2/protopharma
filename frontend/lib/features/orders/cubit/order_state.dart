import 'package:equatable/equatable.dart';

import '../models/order_item.dart';

/// Immutable state for the current order (a simple in-memory cart).
class OrderState extends Equatable {
  const OrderState({this.items = const []});

  final List<OrderItem> items;

  /// Number of distinct line items in the order.
  int get itemCount => items.length;

  /// Sum of all line totals before any adjustments.
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Placeholder for insurance/discounts — wire real logic in here later.
  double get insuranceCoverage => 0.0;

  /// Amount the customer owes after coverage.
  double get totalDue => subtotal - insuranceCoverage;

  OrderState copyWith({List<OrderItem>? items}) =>
      OrderState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}
