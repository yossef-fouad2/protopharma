import 'package:equatable/equatable.dart';
import 'package:protopharma/features/home/models/inventory_alert.dart';

/// State for the critical alerts panel on the dashboard.
///
/// The panel shows one category at a time ([selectedType]) with its own
/// pagination. Live per-category counts ([counts]) drive the tab badges and
/// total page count, and update reactively with the inventory table.
class AlertsState extends Equatable {
  const AlertsState({
    required this.selectedType,
    required this.counts,
    required this.alerts,
    required this.currentPage,
    required this.status,
  });

  /// Initial state: expiring tab isn't selected first; out-of-stock is the most
  /// urgent, so it leads.
  const AlertsState.initial()
    : selectedType = AlertType.outOfStock,
      counts = const AlertCounts.empty(),
      alerts = const [],
      currentPage = 1,
      status = AlertsStatus.loading;

  /// Currently displayed alert category.
  final AlertType selectedType;

  /// Live counts per category (drives tab badges + page count).
  final AlertCounts counts;

  /// Alerts for the current page of [selectedType].
  final List<InventoryAlert> alerts;

  /// 1-based page index within [selectedType].
  final int currentPage;

  final AlertsStatus status;

  /// Total number of alerts in the selected category.
  int get totalInSelected => counts.forType(selectedType);

  AlertsState copyWith({
    AlertType? selectedType,
    AlertCounts? counts,
    List<InventoryAlert>? alerts,
    int? currentPage,
    AlertsStatus? status,
  }) {
    return AlertsState(
      selectedType: selectedType ?? this.selectedType,
      counts: counts ?? this.counts,
      alerts: alerts ?? this.alerts,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    selectedType,
    counts,
    alerts,
    currentPage,
    status,
  ];
}

enum AlertsStatus { loading, ready, error }
