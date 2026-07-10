// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DrugTableTable extends DrugTable
    with TableInfo<$DrugTableTable, DrugTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrugTableTable(this.attachedDatabase, [this._alias]);
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    } else if (isInserting) {
      context.missing(_commercialNameARMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(
          data['scientific_name']!,
          _scientificNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manufacturerMeta);
    }
    if (data.containsKey('drug_class')) {
      context.handle(
        _drugClassMeta,
        drugClass.isAcceptableOrUnknown(data['drug_class']!, _drugClassMeta),
      );
    } else if (isInserting) {
      context.missing(_drugClassMeta);
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    } else if (isInserting) {
      context.missing(_routeMeta);
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
  final int id;
  final String commercialNameEn;
  final String commercialNameAR;
  final String scientificName;
  final String manufacturer;
  final String drugClass;
  final String route;
  final double priceEGP;
  const DrugTableData({
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
    int? id,
    String? commercialNameEn,
    String? commercialNameAR,
    String? scientificName,
    String? manufacturer,
    String? drugClass,
    String? route,
    double? priceEGP,
  }) => DrugTableData(
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
  final Value<int> id;
  final Value<String> commercialNameEn;
  final Value<String> commercialNameAR;
  final Value<String> scientificName;
  final Value<String> manufacturer;
  final Value<String> drugClass;
  final Value<String> route;
  final Value<double> priceEGP;
  const DrugTableCompanion({
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
    this.id = const Value.absent(),
    required String commercialNameEn,
    required String commercialNameAR,
    required String scientificName,
    required String manufacturer,
    required String drugClass,
    required String route,
    required double priceEGP,
  }) : commercialNameEn = Value(commercialNameEn),
       commercialNameAR = Value(commercialNameAR),
       scientificName = Value(scientificName),
       manufacturer = Value(manufacturer),
       drugClass = Value(drugClass),
       route = Value(route),
       priceEGP = Value(priceEGP);
  static Insertable<DrugTableData> custom({
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DrugTableTable drugTable = $DrugTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [drugTable];
}

typedef $$DrugTableTableCreateCompanionBuilder =
    DrugTableCompanion Function({
      Value<int> id,
      required String commercialNameEn,
      required String commercialNameAR,
      required String scientificName,
      required String manufacturer,
      required String drugClass,
      required String route,
      required double priceEGP,
    });
typedef $$DrugTableTableUpdateCompanionBuilder =
    DrugTableCompanion Function({
      Value<int> id,
      Value<String> commercialNameEn,
      Value<String> commercialNameAR,
      Value<String> scientificName,
      Value<String> manufacturer,
      Value<String> drugClass,
      Value<String> route,
      Value<double> priceEGP,
    });

class $$DrugTableTableFilterComposer
    extends Composer<_$AppDatabase, $DrugTableTable> {
  $$DrugTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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
          (
            DrugTableData,
            BaseReferences<_$AppDatabase, $DrugTableTable, DrugTableData>,
          ),
          DrugTableData,
          PrefetchHooks Function()
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
                Value<int> id = const Value.absent(),
                Value<String> commercialNameEn = const Value.absent(),
                Value<String> commercialNameAR = const Value.absent(),
                Value<String> scientificName = const Value.absent(),
                Value<String> manufacturer = const Value.absent(),
                Value<String> drugClass = const Value.absent(),
                Value<String> route = const Value.absent(),
                Value<double> priceEGP = const Value.absent(),
              }) => DrugTableCompanion(
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
                Value<int> id = const Value.absent(),
                required String commercialNameEn,
                required String commercialNameAR,
                required String scientificName,
                required String manufacturer,
                required String drugClass,
                required String route,
                required double priceEGP,
              }) => DrugTableCompanion.insert(
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        DrugTableData,
        BaseReferences<_$AppDatabase, $DrugTableTable, DrugTableData>,
      ),
      DrugTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DrugTableTableTableManager get drugTable =>
      $$DrugTableTableTableManager(_db, _db.drugTable);
}
