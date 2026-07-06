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
    _initTotalPages().then((_) => _loadInventory(_currentPage));
  }
  final DrugsRepository drugRepository;
  // ── State variables ──
  bool _isLoading = false;
  bool _hasMore = true;
  static const int pageSize = 10;
  int _totalPages = 1;
  int _totalCount = 0;

  int get totalPages => _totalPages;
  int get totalCount => _totalCount;

  int get _currentPage =>
      state is InventorySuccess ? (state as InventorySuccess).currentPage : 1;

  Future<void> _loadInventory(int page) async {
    if (_isLoading || page < 1) return;
    _isLoading = true;

    try {
      //1
      final List<DrugModel> drugs = await drugRepository.getLocalDrugs(
        offset: (page - 1) * pageSize,
        limit: pageSize,
      );
      if (drugs.length < pageSize) {
        _hasMore = false; // We reached the end of the database.
      }

      _isLoading = false;
      //2
      emit(
        InventorySuccess(
          drugs: List.unmodifiable(drugs),
          hasMore: _hasMore,
          isLoadingMore: false,
          currentPage: page,
        ),
      );
    } catch (_) {
      emit(InventoryFailure());
    } finally {
      _isLoading = false;
    }
  }

  ///to-do
  ///make the footer widget to display the pages number
  ///and make it listents to the _currentPage
  ///then we need to start making
  /// the filters (search , category , stock status => to be made later)

  Future<void> _initTotalPages() async {
    _totalCount = await drugRepository.getTotalDrugCount();
    _totalPages = (_totalCount / pageSize).ceil();
  }

  // Helper shortcuts used by [<] and [>] buttons
  void nextPage() => _loadInventory(_currentPage + 1);
  void previousPage() => _loadInventory(_currentPage - 1);
  void goToPage(int page) => _loadInventory(page);
}
