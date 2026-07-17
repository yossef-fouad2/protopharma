/// Stock status buckets used for color-coding the inventory UI.
enum StockStatus { outOfStock, low, inStock }

class DrugModel {
  final int? id;
  final String commercialNameEn;
  final String commercialNameAR;
  final String scientificName;
  final String manufacturer;
  final String drugClass;
  final String route;
  final double priceEGP;

  /// Total stock across all inventory batches for this drug.
  /// Null means "stock not loaded"; 0 means genuinely out of stock.
  final int? totalStock;

  /// Nearest (soonest) expiry date across batches, ISO-8601 (yyyy-MM-dd).
  final String? nearestExpiry;

  const DrugModel({
    this.id,
    required this.commercialNameEn,
    required this.commercialNameAR,
    required this.scientificName,
    required this.manufacturer,
    required this.drugClass,
    required this.route,
    required this.priceEGP,
    this.totalStock,
    this.nearestExpiry,
  });

  /// Threshold below which stock is considered "low" for alerts/badges.
  static const int lowStockThreshold = 10;

  /// Convenience: current stock treated as 0 when not loaded.
  int get stock => totalStock ?? 0;

  bool get isInStock => stock > 0;

  StockStatus get stockStatus {
    if (stock <= 0) return StockStatus.outOfStock;
    if (stock <= lowStockThreshold) return StockStatus.low;
    return StockStatus.inStock;
  }

  DrugModel copyWith({int? id, int? totalStock, String? nearestExpiry}) {
    return DrugModel(
      id: id ?? this.id,
      commercialNameEn: commercialNameEn,
      commercialNameAR: commercialNameAR,
      scientificName: scientificName,
      manufacturer: manufacturer,
      drugClass: drugClass,
      route: route,
      priceEGP: priceEGP,
      totalStock: totalStock ?? this.totalStock,
      nearestExpiry: nearestExpiry ?? this.nearestExpiry,
    );
  }

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      commercialNameEn:
          json['commercialNameEn'] ?? json['commercial_name_en'] ?? '',
      commercialNameAR:
          json['commercialNameAR'] ?? json['commercial_name_ar'] ?? '',
      scientificName: json['scientificName'] ?? json['scientific_name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      drugClass: json['drugClass'] ?? json['drug_class'] ?? '',
      route: json['route'] ?? '',
      priceEGP: ((json['priceEGP'] ?? json['price_egp'] ?? 0.0) as num)
          .toDouble(),
    );
  }
}

Map<String, dynamic> toJson(DrugModel drug) {
  return {
    'commercial_name_en': drug.commercialNameEn,
    'commercial_name_ar': drug.commercialNameAR,
    'scientific_name': drug.scientificName,
    'manufacturer': drug.manufacturer,
    'drug_class': drug.drugClass,
    'route': drug.route,
    'price_egp': drug.priceEGP,
  };
}
