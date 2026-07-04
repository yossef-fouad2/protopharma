import 'package:equatable/equatable.dart';
import 'package:protopharma/features/drugs/models/drug_model.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();
}

class InventoryInProgress extends InventoryState {
  const InventoryInProgress();

  @override
  List<Object?> get props => [];
}

class InventorySuccess extends InventoryState {
  const InventorySuccess({
    required this.drugs,
    required this.hasMore,
    required this.isLoadingMore,
    required this.currentPage,
  });

  final List<DrugModel> drugs;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;

  @override
  List<Object?> get props => [drugs, hasMore, isLoadingMore, currentPage];
}

class InventoryFailure extends InventoryState {
  const InventoryFailure();

  @override
  List<Object?> get props => [];
}
