import 'package:flutter_bloc/flutter_bloc.dart';

import '../../drugs/models/drug_model.dart';
import '../models/order_item.dart';
import 'order_state.dart';

/// Manages the current order (an in-memory cart of [OrderItem]s).
///
/// Public API:
///   - [addDrug]     – add a drug or bump its quantity by one
///   - [decrement]   – lower quantity by one (removes the line at zero)
///   - [setQuantity] – set an explicit quantity (removes the line at <= 0)
///   - [removeDrug]  – drop a line entirely
///   - [clear]       – empty the whole order
class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  void addDrug(DrugModel drug) {
    final index = state.items.indexWhere((item) => item.drug.id == drug.id);
    final items = [...state.items];
    if (index == -1) {
      items.add(OrderItem(drug: drug));
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }
    emit(state.copyWith(items: items));
  }

  void decrement(int drugId) {
    final index = state.items.indexWhere((item) => item.drug.id == drugId);
    if (index == -1) return;
    final current = state.items[index];
    final items = [...state.items];
    if (current.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = current.copyWith(quantity: current.quantity - 1);
    }
    emit(state.copyWith(items: items));
  }

  void setQuantity(int drugId, int quantity) {
    if (quantity <= 0) {
      removeDrug(drugId);
      return;
    }
    final index = state.items.indexWhere((item) => item.drug.id == drugId);
    if (index == -1) return;
    final items = [...state.items];
    items[index] = items[index].copyWith(quantity: quantity);
    emit(state.copyWith(items: items));
  }

  void removeDrug(int drugId) => emit(
    state.copyWith(
      items: state.items.where((item) => item.drug.id != drugId).toList(),
    ),
  );

  void clear() => emit(const OrderState());
}
