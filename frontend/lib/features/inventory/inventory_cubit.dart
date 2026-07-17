import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/features/inventory/inventory_state.dart';

import '../drugs/models/drug_model.dart';

/// Cubit that manages inventory listing with pagination, search, and category
/// filtering.
///
/// Public API:
///   - [updateSearchQuery] – debounced text search
///   - [updateCategory]    – instant category filter
///   - [nextPage] / [previousPage] / [goToPage] – pagination
class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit({required this.drugRepository})
    : super(const InventoryInProgress()) {
    _init();
  }

  final DrugsRepository drugRepository;

  // ── Pagination ──────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _hasMore = true;
  static const int pageSize = 9;
  int _totalPages = 1;
  int _totalCount = 0;

  int get totalPages => _totalPages;
  int get totalCount => _totalCount;

  int get _currentPage =>
      state is InventorySuccess ? (state as InventorySuccess).currentPage : 1;

  // ── Search & filter ─────────────────────────────────────────────────────
  String _searchQuery = '';
  String? _selectedCategory;
  bool _inStockOnly = false;
  List<String> _categories = [];
  Timer? _debounce;

  /// Unique drug categories loaded from the database.
  List<String> get categories => List.unmodifiable(_categories);

  // ── Initialization ──────────────────────────────────────────────────────

  Future<void> _init() async {
    _categories = await drugRepository.getDistinctCategories();
    await _refreshCounts();
    await _loadInventory(1);
  }

  // ── Core loader (respects active filters) ──────────────────────────────

  Future<void> _loadInventory(int page) async {
    if (_isLoading || page < 1) return;
    _isLoading = true;

    try {
      final List<DrugModel> drugs = await drugRepository.searchLocalDrugs(
        query: _searchQuery.isEmpty ? null : _searchQuery,
        category: _selectedCategory,
        inStockOnly: _inStockOnly,
        offset: (page - 1) * pageSize,
        limit: pageSize,
      );

      _hasMore = drugs.length >= pageSize;
      _isLoading = false;

      emit(
        InventorySuccess(
          drugs: List.unmodifiable(drugs),
          hasMore: _hasMore,
          isLoadingMore: false,
          currentPage: page,
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
          inStockOnly: _inStockOnly,
        ),
      );
    } catch (_) {
      emit(const InventoryFailure());
    } finally {
      _isLoading = false;
    }
  }

  /// Recalculates [_totalCount] and [_totalPages] for the active filters.
  Future<void> _refreshCounts() async {
    _totalCount = await drugRepository.getFilteredDrugCount(
      query: _searchQuery.isEmpty ? null : _searchQuery,
      category: _selectedCategory,
      inStockOnly: _inStockOnly,
    );

    _totalPages = (_totalCount / pageSize).ceil().clamp(
      1,
      double.maxFinite.toInt(),
    );
  }

  // ── Public search / filter API ─────────────────────────────────────────

  /// Updates the text search query with a 400 ms debounce to avoid excessive
  /// DB hits while the user is typing.
  void updateSearchQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      _searchQuery = query;
      await _refreshCounts();
      await _loadInventory(1);
    });
  }

  /// Sets the category filter and immediately reloads from page 1.
  void updateCategory(String? category) async {
    _selectedCategory = category;
    await _refreshCounts();
    await _loadInventory(1);
  }

  /// Toggles the "in stock only" filter (hides drugs with 0 total stock).
  void toggleInStockOnly(bool value) async {
    _inStockOnly = value;
    await _refreshCounts();
    await _loadInventory(1);
  }

  // ── Pagination helpers ─────────────────────────────────────────────────

  void nextPage() => _loadInventory(_currentPage + 1);
  void previousPage() => _loadInventory(_currentPage - 1);
  void goToPage(int page) => _loadInventory(page);

  // ── Cleanup ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
