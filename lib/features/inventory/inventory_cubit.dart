import 'package:flutter/material.dart';
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
    _loadInventory(_currentPage);
  }
  final DrugsRepository drugRepository;
  // final String drugId;

  // ── State variables ──
  bool _isLoading = false;
  bool _hasMore = true;
  static const int _pageSize = 10;
  // Drop the field entirely, derive it when needed:
  int get _currentPage =>
      state is InventorySuccess ? (state as InventorySuccess).currentPage : 1;

  Future<void> _loadInventory(int page) async {
    if (_isLoading || page < 1) return;
    _isLoading = true;

    try {
      //1
      final List<DrugModel> drugs = await drugRepository.getLocalDrugs(
        offset: (page - 1) * _pageSize,
        limit: _pageSize,
      );
      if (drugs.length < _pageSize) {
        _hasMore = false; // We reached the end of the database.
      }

      _isLoading = false;
      //2
      emit(
        InventorySuccess(
          drugs: List.unmodifiable(drugs),
          hasMore: _hasMore,
          isLoadingMore: _isLoading,
          currentPage: _currentPage,
        ),
      );
    } catch (_) {
      emit(InventoryFailure());
    } finally {
      _isLoading = false;
    }
  }

  // Helper shortcuts used by [<] and [>] buttons
  void nextPage() => _loadInventory(_currentPage + 1);
  void previousPage() => _loadInventory(_currentPage - 1);
}
