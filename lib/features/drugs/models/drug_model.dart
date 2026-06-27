
class DrugModel {
  final String commercialNameEn;
  final String commercialNameAR;
  final String scientificName;
  final String manufacturer;
  final String drugClass;
  final String route;
  final double priceEGP;

  const DrugModel({
    required this.commercialNameEn,
    required this.commercialNameAR,
    required this.scientificName,
    required this.manufacturer,
    required this.drugClass,
    required this.route,
    required this.priceEGP,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      commercialNameEn: json['commercialNameEn'] ?? json['commercial_name_en'] ?? '',
      commercialNameAR: json['commercialNameAR'] ?? json['commercial_name_ar'] ?? '',
      scientificName: json['scientificName'] ?? json['scientific_name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      drugClass: json['drugClass'] ?? json['drug_class'] ?? '',
      route: json['route'] ?? '',
      priceEGP: ((json['priceEGP'] ?? json['price_egp'] ?? 0.0) as num).toDouble(),
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
