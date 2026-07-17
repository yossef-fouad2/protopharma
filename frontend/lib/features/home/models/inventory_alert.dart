import 'package:equatable/equatable.dart';

/// Severity level used to color-code an alert in the UI.
enum AlertSeverity { critical, warning }

/// The kind of inventory problem that triggered the alert.
enum AlertType { outOfStock, lowStock, expiringSoon }

/// A single critical alert derived from the inventory table.
///
/// These are computed reactively from live inventory data (stock levels and
/// batch expiry dates) rather than being hard-coded demo values.
class InventoryAlert extends Equatable {
  const InventoryAlert({
    required this.drugId,
    required this.drugName,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  final int drugId;
  final String drugName;
  final AlertType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String actionLabel;

  @override
  List<Object?> get props => [
    drugId,
    drugName,
    type,
    severity,
    title,
    description,
    actionLabel,
  ];
}

/// Live counts per alert category, used to drive the panel's tab badges and
/// pagination without loading the actual alert rows.
class AlertCounts extends Equatable {
  const AlertCounts({
    required this.outOfStock,
    required this.lowStock,
    required this.expiring,
  });

  const AlertCounts.empty() : outOfStock = 0, lowStock = 0, expiring = 0;

  final int outOfStock;
  final int lowStock;
  final int expiring;

  int get total => outOfStock + lowStock + expiring;

  /// Returns the count for a given [type].
  int forType(AlertType type) => switch (type) {
    AlertType.outOfStock => outOfStock,
    AlertType.lowStock => lowStock,
    AlertType.expiringSoon => expiring,
  };

  @override
  List<Object?> get props => [outOfStock, lowStock, expiring];
}
