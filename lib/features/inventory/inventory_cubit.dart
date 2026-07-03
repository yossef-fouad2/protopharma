import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/features/inventory/inventory_state.dart';

import '../drugs/models/drug_model.dart';

///make new events load first page on openning
///
/// load_next_page
///
/// pageNumbers [1,2,3,4,5] when click on next it should
///
/// handle refresh

class InventoryCubit extends Cubit<InventoryState> {
  // final AppDatabase db;
  InventoryCubit({required this.drugRepository})
    : super(const InventoryInProgress()) {
    _loadInventory();
  }
  final DrugsRepository drugRepository;
  // final String drugId;

  // ── State variables ──
  final List<DrugModel> _allDrugs = [];
  bool _isLoading = false;
  bool _hasMore = true;

  Future<void> _loadInventory() async {
    _isLoading = true;
    try {
      //1
      final List<DrugModel> drugs = await drugRepository.getLocalDrugs(
        offset: _allDrugs.length,
        limit: 10,
      );
      if (drugs.length < 10) {
        _hasMore = false; // We reached the end of the database.
      }
      _allDrugs.addAll(drugs);
      _isLoading = false;
      //2
      emit(
        InventorySuccess(
          drugs: List.unmodifiable(_allDrugs),
          hasMore: _hasMore,
          isLoadingMore: _isLoading,
        ),
      );
    } catch (error) {
      _isLoading = false;
      emit(InventoryFailure());
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    if (!_hasMore) return;
    emit(
      InventorySuccess(
        drugs: List.unmodifiable(_allDrugs),
        hasMore: _hasMore,
        isLoadingMore: true,
      ),
    );
    _loadInventory();
  }
}
