// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DrugTableTable extends DrugTable
    with TableInfo<$DrugTableTable, DrugTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrugTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _commercialNameEnMeta = const VerificationMeta(
    'commercialNameEn',
  );
  @override
  late final GeneratedColumn<String> commercialNameEn = GeneratedColumn<String>(
    'commercial_name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commercialNameARMeta = const VerificationMeta(
    'commercialNameAR',
  );
  @override
  late final GeneratedColumn<String> commercialNameAR = GeneratedColumn<String>(
    'commercial_name_a_r',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _scientificNameMeta = const VerificationMeta(
    'scientificName',
  );
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
    'scientific_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _drugClassMeta = const VerificationMeta(
    'drugClass',
  );
  @override
  late final GeneratedColumn<String> drugClass = GeneratedColumn<String>(
    'drug_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _priceEGPMeta = const VerificationMeta(
    'priceEGP',
  );
  @override
  late final GeneratedColumn<double> priceEGP = GeneratedColumn<double>(
    'price_e_g_p',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    deletedAt,
    id,
    commercialNameEn,
    commercialNameAR,
    scientificName,
    manufacturer,
    drugClass,
    route,
    priceEGP,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drug_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrugTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('commercial_name_en')) {
      context.handle(
        _commercialNameEnMeta,
        commercialNameEn.isAcceptableOrUnknown(
          data['commercial_name_en']!,
          _commercialNameEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commercialNameEnMeta);
    }
    if (data.containsKey('commercial_name_a_r')) {
      context.handle(
        _commercialNameARMeta,
        commercialNameAR.isAcceptableOrUnknown(
          data['commercial_name_a_r']!,
          _commercialNameARMeta,
        ),
      );
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(
          data['scientific_name']!,
          _scientificNameMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('drug_class')) {
      context.handle(
        _drugClassMeta,
        drugClass.isAcceptableOrUnknown(data['drug_class']!, _drugClassMeta),
      );
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    }
    if (data.containsKey('price_e_g_p')) {
      context.handle(
        _priceEGPMeta,
        priceEGP.isAcceptableOrUnknown(data['price_e_g_p']!, _priceEGPMeta),
      );
    } else if (isInserting) {
      context.missing(_priceEGPMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrugTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrugTableData(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      commercialNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}commercial_name_en'],
      )!,
      commercialNameAR: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}commercial_name_a_r'],
      )!,
      scientificName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_name'],
      )!,
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      )!,
      drugClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drug_class'],
      )!,
      route: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route'],
      )!,
      priceEGP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_e_g_p'],
      )!,
    );
  }

  @override
  $DrugTableTable createAlias(String alias) {
    return $DrugTableTable(attachedDatabase, alias);
  }
}

class DrugTableData extends DataClass implements Insertable<DrugTableData> {
  /// Row creation time. Defaults to now on insert.
  final DateTime createdAt;

  /// Last update time. Defaults to now; keep in sync on updates in app code.
  final DateTime updatedAt;

  /// Soft-delete marker. `null` = active, non-null = soft-deleted.
  final DateTime? deletedAt;
  final int id;
  final String commercialNameEn;
  final String commercialNameAR;
  final String scientificName;
  final String manufacturer;
  final String drugClass;
  final String route;
  final double priceEGP;
  const DrugTableData({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.commercialNameEn,
    required this.commercialNameAR,
    required this.scientificName,
    required this.manufacturer,
    required this.drugClass,
    required this.route,
    required this.priceEGP,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['id'] = Variable<int>(id);
    map['commercial_name_en'] = Variable<String>(commercialNameEn);
    map['commercial_name_a_r'] = Variable<String>(commercialNameAR);
    map['scientific_name'] = Variable<String>(scientificName);
    map['manufacturer'] = Variable<String>(manufacturer);
    map['drug_class'] = Variable<String>(drugClass);
    map['route'] = Variable<String>(route);
    map['price_e_g_p'] = Variable<double>(priceEGP);
    return map;
  }

  DrugTableCompanion toCompanion(bool nullToAbsent) {
    return DrugTableCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      commercialNameEn: Value(commercialNameEn),
      commercialNameAR: Value(commercialNameAR),
      scientificName: Value(scientificName),
      manufacturer: Value(manufacturer),
      drugClass: Value(drugClass),
      route: Value(route),
      priceEGP: Value(priceEGP),
    );
  }

  factory DrugTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrugTableData(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      id: serializer.fromJson<int>(json['id']),
      commercialNameEn: serializer.fromJson<String>(json['commercialNameEn']),
      commercialNameAR: serializer.fromJson<String>(json['commercialNameAR']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      manufacturer: serializer.fromJson<String>(json['manufacturer']),
      drugClass: serializer.fromJson<String>(json['drugClass']),
      route: serializer.fromJson<String>(json['route']),
      priceEGP: serializer.fromJson<double>(json['priceEGP']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'id': serializer.toJson<int>(id),
      'commercialNameEn': serializer.toJson<String>(commercialNameEn),
      'commercialNameAR': serializer.toJson<String>(commercialNameAR),
      'scientificName': serializer.toJson<String>(scientificName),
      'manufacturer': serializer.toJson<String>(manufacturer),
      'drugClass': serializer.toJson<String>(drugClass),
      'route': serializer.toJson<String>(route),
      'priceEGP': serializer.toJson<double>(priceEGP),
    };
  }

  DrugTableData copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? id,
    String? commercialNameEn,
    String? commercialNameAR,
    String? scientificName,
    String? manufacturer,
    String? drugClass,
    String? route,
    double? priceEGP,
  }) => DrugTableData(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    commercialNameEn: commercialNameEn ?? this.commercialNameEn,
    commercialNameAR: commercialNameAR ?? this.commercialNameAR,
    scientificName: scientificName ?? this.scientificName,
    manufacturer: manufacturer ?? this.manufacturer,
    drugClass: drugClass ?? this.drugClass,
    route: route ?? this.route,
    priceEGP: priceEGP ?? this.priceEGP,
  );
  DrugTableData copyWithCompanion(DrugTableCompanion data) {
    return DrugTableData(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      commercialNameEn: data.commercialNameEn.present
          ? data.commercialNameEn.value
          : this.commercialNameEn,
      commercialNameAR: data.commercialNameAR.present
          ? data.commercialNameAR.value
          : this.commercialNameAR,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      drugClass: data.drugClass.present ? data.drugClass.value : this.drugClass,
      route: data.route.present ? data.route.value : this.route,
      priceEGP: data.priceEGP.present ? data.priceEGP.value : this.priceEGP,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrugTableData(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('commercialNameEn: $commercialNameEn, ')
          ..write('commercialNameAR: $commercialNameAR, ')
          ..write('scientificName: $scientificName, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('drugClass: $drugClass, ')
          ..write('route: $route, ')
          ..write('priceEGP: $priceEGP')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    deletedAt,
    id,
    commercialNameEn,
    commercialNameAR,
    scientificName,
    manufacturer,
    drugClass,
    route,
    priceEGP,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrugTableData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.commercialNameEn == this.commercialNameEn &&
          other.commercialNameAR == this.commercialNameAR &&
          other.scientificName == this.scientificName &&
          other.manufacturer == this.manufacturer &&
          other.drugClass == this.drugClass &&
          other.route == this.route &&
          other.priceEGP == this.priceEGP);
}

class DrugTableCompanion extends UpdateCompanion<DrugTableData> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> id;
  final Value<String> commercialNameEn;
  final Value<String> commercialNameAR;
  final Value<String> scientificName;
  final Value<String> manufacturer;
  final Value<String> drugClass;
  final Value<String> route;
  final Value<double> priceEGP;
  const DrugTableCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.commercialNameEn = const Value.absent(),
    this.commercialNameAR = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.drugClass = const Value.absent(),
    this.route = const Value.absent(),
    this.priceEGP = const Value.absent(),
  });
  DrugTableCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String commercialNameEn,
    this.commercialNameAR = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.drugClass = const Value.absent(),
    this.route = const Value.absent(),
    required double priceEGP,
  }) : commercialNameEn = Value(commercialNameEn),
       priceEGP = Value(priceEGP);
  static Insertable<DrugTableData> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? id,
    Expression<String>? commercialNameEn,
    Expression<String>? commercialNameAR,
    Expression<String>? scientificName,
    Expression<String>? manufacturer,
    Expression<String>? drugClass,
    Expression<String>? route,
    Expression<double>? priceEGP,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (commercialNameEn != null) 'commercial_name_en': commercialNameEn,
      if (commercialNameAR != null) 'commercial_name_a_r': commercialNameAR,
      if (scientificName != null) 'scientific_name': scientificName,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (drugClass != null) 'drug_class': drugClass,
      if (route != null) 'route': route,
      if (priceEGP != null) 'price_e_g_p': priceEGP,
    });
  }

  DrugTableCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? id,
    Value<String>? commercialNameEn,
    Value<String>? commercialNameAR,
    Value<String>? scientificName,
    Value<String>? manufacturer,
    Value<String>? drugClass,
    Value<String>? route,
    Value<double>? priceEGP,
  }) {
    return DrugTableCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      commercialNameEn: commercialNameEn ?? this.commercialNameEn,
      commercialNameAR: commercialNameAR ?? this.commercialNameAR,
      scientificName: scientificName ?? this.scientificName,
      manufacturer: manufacturer ?? this.manufacturer,
      drugClass: drugClass ?? this.drugClass,
      route: route ?? this.route,
      priceEGP: priceEGP ?? this.priceEGP,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (commercialNameEn.present) {
      map['commercial_name_en'] = Variable<String>(commercialNameEn.value);
    }
    if (commercialNameAR.present) {
      map['commercial_name_a_r'] = Variable<String>(commercialNameAR.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (drugClass.present) {
      map['drug_class'] = Variable<String>(drugClass.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (priceEGP.present) {
      map['price_e_g_p'] = Variable<double>(priceEGP.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrugTableCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('commercialNameEn: $commercialNameEn, ')
          ..write('commercialNameAR: $commercialNameAR, ')
          ..write('scientificName: $scientificName, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('drugClass: $drugClass, ')
          ..write('route: $route, ')
          ..write('priceEGP: $priceEGP')
          ..write(')'))
        .toString();
  }
}

class $InventoryTableTable extends InventoryTable
    with TableInfo<$InventoryTableTable, InventoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _drugIdMeta = const VerificationMeta('drugId');
  @override
  late final GeneratedColumn<int> drugId = GeneratedColumn<int>(
    'drug_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES drug_table (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
    'batch_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N/A'),
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    deletedAt,
    id,
    drugId,
    quantity,
    batchNumber,
    expiryDate,
    purchasePrice,
    sellingPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('drug_id')) {
      context.handle(
        _drugIdMeta,
        drugId.isAcceptableOrUnknown(data['drug_id']!, _drugIdMeta),
      );
    } else if (isInserting) {
      context.missing(_drugIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryTableData(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      drugId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drug_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_number'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_date'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selling_price'],
      )!,
    );
  }

  @override
  $InventoryTableTable createAlias(String alias) {
    return $InventoryTableTable(attachedDatabase, alias);
  }
}

class InventoryTableData extends DataClass
    implements Insertable<InventoryTableData> {
  /// Row creation time. Defaults to now on insert.
  final DateTime createdAt;

  /// Last update time. Defaults to now; keep in sync on updates in app code.
  final DateTime updatedAt;

  /// Soft-delete marker. `null` = active, non-null = soft-deleted.
  final DateTime? deletedAt;
  final int id;

  /// Foreign key → DrugTable.id
  final int drugId;
  final int quantity;
  final String batchNumber;

  /// Stored as ISO-8601 date string (yyyy-MM-dd) for simple sorting/filtering.
  final String expiryDate;
  final double purchasePrice;
  final double sellingPrice;
  const InventoryTableData({
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.drugId,
    required this.quantity,
    required this.batchNumber,
    required this.expiryDate,
    required this.purchasePrice,
    required this.sellingPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['id'] = Variable<int>(id);
    map['drug_id'] = Variable<int>(drugId);
    map['quantity'] = Variable<int>(quantity);
    map['batch_number'] = Variable<String>(batchNumber);
    map['expiry_date'] = Variable<String>(expiryDate);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['selling_price'] = Variable<double>(sellingPrice);
    return map;
  }

  InventoryTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryTableCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      id: Value(id),
      drugId: Value(drugId),
      quantity: Value(quantity),
      batchNumber: Value(batchNumber),
      expiryDate: Value(expiryDate),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
    );
  }

  factory InventoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryTableData(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      id: serializer.fromJson<int>(json['id']),
      drugId: serializer.fromJson<int>(json['drugId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      batchNumber: serializer.fromJson<String>(json['batchNumber']),
      expiryDate: serializer.fromJson<String>(json['expiryDate']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'id': serializer.toJson<int>(id),
      'drugId': serializer.toJson<int>(drugId),
      'quantity': serializer.toJson<int>(quantity),
      'batchNumber': serializer.toJson<String>(batchNumber),
      'expiryDate': serializer.toJson<String>(expiryDate),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
    };
  }

  InventoryTableData copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? id,
    int? drugId,
    int? quantity,
    String? batchNumber,
    String? expiryDate,
    double? purchasePrice,
    double? sellingPrice,
  }) => InventoryTableData(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    id: id ?? this.id,
    drugId: drugId ?? this.drugId,
    quantity: quantity ?? this.quantity,
    batchNumber: batchNumber ?? this.batchNumber,
    expiryDate: expiryDate ?? this.expiryDate,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    sellingPrice: sellingPrice ?? this.sellingPrice,
  );
  InventoryTableData copyWithCompanion(InventoryTableCompanion data) {
    return InventoryTableData(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      id: data.id.present ? data.id.value : this.id,
      drugId: data.drugId.present ? data.drugId.value : this.drugId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTableData(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('drugId: $drugId, ')
          ..write('quantity: $quantity, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    deletedAt,
    id,
    drugId,
    quantity,
    batchNumber,
    expiryDate,
    purchasePrice,
    sellingPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryTableData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.id == this.id &&
          other.drugId == this.drugId &&
          other.quantity == this.quantity &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.purchasePrice == this.purchasePrice &&
          other.sellingPrice == this.sellingPrice);
}

class InventoryTableCompanion extends UpdateCompanion<InventoryTableData> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> id;
  final Value<int> drugId;
  final Value<int> quantity;
  final Value<String> batchNumber;
  final Value<String> expiryDate;
  final Value<double> purchasePrice;
  final Value<double> sellingPrice;
  const InventoryTableCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.drugId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
  });
  InventoryTableCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.id = const Value.absent(),
    required int drugId,
    this.quantity = const Value.absent(),
    this.batchNumber = const Value.absent(),
    required String expiryDate,
    this.purchasePrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
  }) : drugId = Value(drugId),
       expiryDate = Value(expiryDate);
  static Insertable<InventoryTableData> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? id,
    Expression<int>? drugId,
    Expression<int>? quantity,
    Expression<String>? batchNumber,
    Expression<String>? expiryDate,
    Expression<double>? purchasePrice,
    Expression<double>? sellingPrice,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (id != null) 'id': id,
      if (drugId != null) 'drug_id': drugId,
      if (quantity != null) 'quantity': quantity,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (sellingPrice != null) 'selling_price': sellingPrice,
    });
  }

  InventoryTableCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? id,
    Value<int>? drugId,
    Value<int>? quantity,
    Value<String>? batchNumber,
    Value<String>? expiryDate,
    Value<double>? purchasePrice,
    Value<double>? sellingPrice,
  }) {
    return InventoryTableCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      drugId: drugId ?? this.drugId,
      quantity: quantity ?? this.quantity,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (drugId.present) {
      map['drug_id'] = Variable<int>(drugId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTableCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('id: $id, ')
          ..write('drugId: $drugId, ')
          ..write('quantity: $quantity, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DrugTableTable drugTable = $DrugTableTable(this);
  late final $InventoryTableTable inventoryTable = $InventoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    drugTable,
    inventoryTable,
  ];
}

typedef $$DrugTableTableCreateCompanionBuilder =
    DrugTableCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> id,
      required String commercialNameEn,
      Value<String> commercialNameAR,
      Value<String> scientificName,
      Value<String> manufacturer,
      Value<String> drugClass,
      Value<String> route,
      required double priceEGP,
    });
typedef $$DrugTableTableUpdateCompanionBuilder =
    DrugTableCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> id,
      Value<String> commercialNameEn,
      Value<String> commercialNameAR,
      Value<String> scientificName,
      Value<String> manufacturer,
      Value<String> drugClass,
      Value<String> route,
      Value<double> priceEGP,
    });

final class $$DrugTableTableReferences
    extends BaseReferences<_$AppDatabase, $DrugTableTable, DrugTableData> {
  $$DrugTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryTableTable, List<InventoryTableData>>
  _inventoryTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryTable,
    aliasName: $_aliasNameGenerator(db.drugTable.id, db.inventoryTable.drugId),
  );

  $$InventoryTableTableProcessedTableManager get inventoryTableRefs {
    final manager = $$InventoryTableTableTableManager(
      $_db,
      $_db.inventoryTable,
    ).filter((f) => f.drugId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DrugTableTableFilterComposer
    extends Composer<_$AppDatabase, $DrugTableTable> {
  $$DrugTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commercialNameEn => $composableBuilder(
    column: $table.commercialNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commercialNameAR => $composableBuilder(
    column: $table.commercialNameAR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drugClass => $composableBuilder(
    column: $table.drugClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceEGP => $composableBuilder(
    column: $table.priceEGP,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryTableRefs(
    Expression<bool> Function($$InventoryTableTableFilterComposer f) f,
  ) {
    final $$InventoryTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryTable,
      getReferencedColumn: (t) => t.drugId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableTableFilterComposer(
            $db: $db,
            $table: $db.inventoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DrugTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DrugTableTable> {
  $$DrugTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commercialNameEn => $composableBuilder(
    column: $table.commercialNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commercialNameAR => $composableBuilder(
    column: $table.commercialNameAR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drugClass => $composableBuilder(
    column: $table.drugClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceEGP => $composableBuilder(
    column: $table.priceEGP,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DrugTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DrugTableTable> {
  $$DrugTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get commercialNameEn => $composableBuilder(
    column: $table.commercialNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get commercialNameAR => $composableBuilder(
    column: $table.commercialNameAR,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get drugClass =>
      $composableBuilder(column: $table.drugClass, builder: (column) => column);

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<double> get priceEGP =>
      $composableBuilder(column: $table.priceEGP, builder: (column) => column);

  Expression<T> inventoryTableRefs<T extends Object>(
    Expression<T> Function($$InventoryTableTableAnnotationComposer a) f,
  ) {
    final $$InventoryTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryTable,
      getReferencedColumn: (t) => t.drugId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DrugTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DrugTableTable,
          DrugTableData,
          $$DrugTableTableFilterComposer,
          $$DrugTableTableOrderingComposer,
          $$DrugTableTableAnnotationComposer,
          $$DrugTableTableCreateCompanionBuilder,
          $$DrugTableTableUpdateCompanionBuilder,
          (DrugTableData, $$DrugTableTableReferences),
          DrugTableData,
          PrefetchHooks Function({bool inventoryTableRefs})
        > {
  $$DrugTableTableTableManager(_$AppDatabase db, $DrugTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrugTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DrugTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrugTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> commercialNameEn = const Value.absent(),
                Value<String> commercialNameAR = const Value.absent(),
                Value<String> scientificName = const Value.absent(),
                Value<String> manufacturer = const Value.absent(),
                Value<String> drugClass = const Value.absent(),
                Value<String> route = const Value.absent(),
                Value<double> priceEGP = const Value.absent(),
              }) => DrugTableCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                commercialNameEn: commercialNameEn,
                commercialNameAR: commercialNameAR,
                scientificName: scientificName,
                manufacturer: manufacturer,
                drugClass: drugClass,
                route: route,
                priceEGP: priceEGP,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String commercialNameEn,
                Value<String> commercialNameAR = const Value.absent(),
                Value<String> scientificName = const Value.absent(),
                Value<String> manufacturer = const Value.absent(),
                Value<String> drugClass = const Value.absent(),
                Value<String> route = const Value.absent(),
                required double priceEGP,
              }) => DrugTableCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                commercialNameEn: commercialNameEn,
                commercialNameAR: commercialNameAR,
                scientificName: scientificName,
                manufacturer: manufacturer,
                drugClass: drugClass,
                route: route,
                priceEGP: priceEGP,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DrugTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inventoryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryTableRefs) db.inventoryTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryTableRefs)
                    await $_getPrefetchedData<
                      DrugTableData,
                      $DrugTableTable,
                      InventoryTableData
                    >(
                      currentTable: table,
                      referencedTable: $$DrugTableTableReferences
                          ._inventoryTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DrugTableTableReferences(
                            db,
                            table,
                            p0,
                          ).inventoryTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.drugId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DrugTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DrugTableTable,
      DrugTableData,
      $$DrugTableTableFilterComposer,
      $$DrugTableTableOrderingComposer,
      $$DrugTableTableAnnotationComposer,
      $$DrugTableTableCreateCompanionBuilder,
      $$DrugTableTableUpdateCompanionBuilder,
      (DrugTableData, $$DrugTableTableReferences),
      DrugTableData,
      PrefetchHooks Function({bool inventoryTableRefs})
    >;
typedef $$InventoryTableTableCreateCompanionBuilder =
    InventoryTableCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> id,
      required int drugId,
      Value<int> quantity,
      Value<String> batchNumber,
      required String expiryDate,
      Value<double> purchasePrice,
      Value<double> sellingPrice,
    });
typedef $$InventoryTableTableUpdateCompanionBuilder =
    InventoryTableCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> id,
      Value<int> drugId,
      Value<int> quantity,
      Value<String> batchNumber,
      Value<String> expiryDate,
      Value<double> purchasePrice,
      Value<double> sellingPrice,
    });

final class $$InventoryTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryTableTable,
          InventoryTableData
        > {
  $$InventoryTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DrugTableTable _drugIdTable(_$AppDatabase db) =>
      db.drugTable.createAlias(
        $_aliasNameGenerator(db.inventoryTable.drugId, db.drugTable.id),
      );

  $$DrugTableTableProcessedTableManager get drugId {
    final $_column = $_itemColumn<int>('drug_id')!;

    final manager = $$DrugTableTableTableManager(
      $_db,
      $_db.drugTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_drugIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$DrugTableTableFilterComposer get drugId {
    final $$DrugTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drugId,
      referencedTable: $db.drugTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrugTableTableFilterComposer(
            $db: $db,
            $table: $db.drugTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$DrugTableTableOrderingComposer get drugId {
    final $$DrugTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drugId,
      referencedTable: $db.drugTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrugTableTableOrderingComposer(
            $db: $db,
            $table: $db.drugTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  $$DrugTableTableAnnotationComposer get drugId {
    final $$DrugTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.drugId,
      referencedTable: $db.drugTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DrugTableTableAnnotationComposer(
            $db: $db,
            $table: $db.drugTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTableTable,
          InventoryTableData,
          $$InventoryTableTableFilterComposer,
          $$InventoryTableTableOrderingComposer,
          $$InventoryTableTableAnnotationComposer,
          $$InventoryTableTableCreateCompanionBuilder,
          $$InventoryTableTableUpdateCompanionBuilder,
          (InventoryTableData, $$InventoryTableTableReferences),
          InventoryTableData,
          PrefetchHooks Function({bool drugId})
        > {
  $$InventoryTableTableTableManager(
    _$AppDatabase db,
    $InventoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> drugId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> batchNumber = const Value.absent(),
                Value<String> expiryDate = const Value.absent(),
                Value<double> purchasePrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
              }) => InventoryTableCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                drugId: drugId,
                quantity: quantity,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required int drugId,
                Value<int> quantity = const Value.absent(),
                Value<String> batchNumber = const Value.absent(),
                required String expiryDate,
                Value<double> purchasePrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
              }) => InventoryTableCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                id: id,
                drugId: drugId,
                quantity: quantity,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                purchasePrice: purchasePrice,
                sellingPrice: sellingPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({drugId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (drugId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.drugId,
                                referencedTable: $$InventoryTableTableReferences
                                    ._drugIdTable(db),
                                referencedColumn:
                                    $$InventoryTableTableReferences
                                        ._drugIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTableTable,
      InventoryTableData,
      $$InventoryTableTableFilterComposer,
      $$InventoryTableTableOrderingComposer,
      $$InventoryTableTableAnnotationComposer,
      $$InventoryTableTableCreateCompanionBuilder,
      $$InventoryTableTableUpdateCompanionBuilder,
      (InventoryTableData, $$InventoryTableTableReferences),
      InventoryTableData,
      PrefetchHooks Function({bool drugId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DrugTableTableTableManager get drugTable =>
      $$DrugTableTableTableManager(_db, _db.drugTable);
  $$InventoryTableTableTableManager get inventoryTable =>
      $$InventoryTableTableTableManager(_db, _db.inventoryTable);
}
