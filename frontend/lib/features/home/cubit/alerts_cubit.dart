import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protopharma/features/drugs/repositories/drugs_repository.dart';
import 'package:protopharma/features/home/cubit/alerts_state.dart';
import 'package:protopharma/features/home/models/inventory_alert.dart';

/// Cubit that keeps the dashboard's critical alerts in sync with the
/// inventory table.
///
/// Design goals:
///   • Stay reactive — per-category counts are watched from the DB and refresh
///     the UI automatically when inventory changes.
///   • Stay fast — alert rows are fetched one page at a time in SQL, so the
///     panel never materialises the whole catalogue (avoids UI freezes).
class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit({required this.drugsRepository})
    : super(const AlertsState.initial()) {
    _watchCounts();
    _loadPage();
  }

  final DrugsRepository drugsRepository;

  /// Alerts shown per page in the panel.
  static const int pageSize = 5;

  StreamSubscription<AlertCounts>? _countsSub;

  /// Total pages available for the selected category.
  int get totalPages {
    final total = state.totalInSelected;
    if (total <= 0) return 1;
    return (total / pageSize).ceil();
  }

  // ── Reactive counts ─────────────────────────────────────────────────────

  void _watchCounts() {
    _countsSub = drugsRepository.watchAlertCounts().listen((counts) {
      emit(state.copyWith(counts: counts));
      // Counts changed (e.g. inventory edited) — make sure the current page
      // is still valid and its rows are fresh.
      _loadPage();
    }, onError: (_) => emit(state.copyWith(status: AlertsStatus.error)));
  }

  // ── Public API ──────────────────────────────────────────────────────────

  /// Switches the visible alert category and resets to the first page.
  void selectType(AlertType type) {
    if (type == state.selectedType) return;
    emit(state.copyWith(selectedType: type, currentPage: 1));
    _loadPage();
  }

  void nextPage() {
    if (state.currentPage >= totalPages) return;
    emit(state.copyWith(currentPage: state.currentPage + 1));
    _loadPage();
  }

  void previousPage() {
    if (state.currentPage <= 1) return;
    emit(state.copyWith(currentPage: state.currentPage - 1));
    _loadPage();
  }

  // ── Page loader ─────────────────────────────────────────────────────────

  Future<void> _loadPage() async {
    // Clamp the page in case counts shrank underneath us.
    final page = state.currentPage.clamp(1, totalPages);

    try {
      final alerts = await drugsRepository.fetchAlerts(
        type: state.selectedType,
        limit: pageSize,
        offset: (page - 1) * pageSize,
      );
      emit(
        state.copyWith(
          alerts: alerts,
          currentPage: page,
          status: AlertsStatus.ready,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: AlertsStatus.error));
    }
  }

  @override
  Future<void> close() {
    _countsSub?.cancel();
    return super.close();
  }
}
