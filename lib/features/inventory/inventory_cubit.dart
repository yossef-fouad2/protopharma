import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/features/inventory/inventory_state.dart';

import '../drugs/models/drug_model.dart';

class InventoryCubit extends Cubit<InventoryState> {
  // final AppDatabase db;
  InventoryCubit({required this.drugRepository})
    : super(const InventoryInProgress()) {
    _loadInventory();
  }
  final DrugsRepository drugRepository;
  // final String drugId;

  // ── Pagination state (private, UI never sees these) ──
  final List<DrugModel> _allDrugs = [];
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  static const _pageSize = 20;

  Future<void> _loadInventory() async {
    _isLoading = true;
    try {
      //1
      final List<DrugModel> drugs = await drugRepository.getLocalDrugs();
      _allDrugs.addAll(drugs);
      _isLoading = false;
      //2
      emit(
        InventorySuccess(
          drugs: List.unmodifiable(_allDrugs),
          hasMore: drugRepository.hasMore,
          isLoadingMore: _isLoading,
        ),
      );
    } catch (error) {
      _isLoading = false;
      emit(InventoryFailure());
    }
  }
}
