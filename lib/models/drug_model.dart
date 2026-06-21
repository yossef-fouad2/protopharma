import 'package:hive/hive.dart';

part 'drug_model.g.dart';

@HiveType(typeId: 1)
class DrugModel {
  @HiveField(0)
  final String commercialNameEn;

  @HiveField(1)
  final String scientificName;

  @HiveField(2)
  final String manufacturer;

  @HiveField(3)
  final String drugClass;

  @HiveField(4)
  final String route;

  @HiveField(5)
  final double priceEGP;

  const DrugModel({
    required this.commercialNameEn,
    required this.scientificName,
    required this.manufacturer,
    required this.drugClass,
    required this.route,
    required this.priceEGP,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      commercialNameEn: json['commercialNameEn'] ?? json['commercial_name_en'] ?? '',
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
    'scientific_name': drug.scientificName,
    'manufacturer': drug.manufacturer,
    'drug_class': drug.drugClass,
    'route': drug.route,
    'price_egp': drug.priceEGP,
  };
}
