/// A single inventory batch (lot) for a drug.
///
/// Mirrors a row in `inventory_table`. Multiple batches can belong to one
/// drug; the aggregated stock badge on the inventory table is the SUM of
/// [quantity] across a drug's active (non-deleted) batches.
class BatchModel {
  final int? id;
  final int drugId;
  final int quantity;
  final String batchNumber;

  /// ISO-8601 date string (yyyy-MM-dd).
  final String expiryDate;
  final double purchasePrice;
  final double sellingPrice;

  const BatchModel({
    this.id,
    required this.drugId,
    required this.quantity,
    required this.batchNumber,
    required this.expiryDate,
    required this.purchasePrice,
    required this.sellingPrice,
  });

  BatchModel copyWith({
    int? id,
    int? drugId,
    int? quantity,
    String? batchNumber,
    String? expiryDate,
    double? purchasePrice,
    double? sellingPrice,
  }) {
    return BatchModel(
      id: id ?? this.id,
      drugId: drugId ?? this.drugId,
      quantity: quantity ?? this.quantity,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }
}
