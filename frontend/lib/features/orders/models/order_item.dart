import 'package:equatable/equatable.dart';

import '../../drugs/models/drug_model.dart';

/// A single line in the current order: a drug paired with its ordered quantity.
class OrderItem extends Equatable {
  const OrderItem({required this.drug, this.quantity = 1});

  final DrugModel drug;
  final int quantity;

  /// Total price for this line (unit price × quantity).
  double get lineTotal => drug.priceEGP * quantity;

  OrderItem copyWith({int? quantity}) =>
      OrderItem(drug: drug, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [drug.id, quantity];
}
