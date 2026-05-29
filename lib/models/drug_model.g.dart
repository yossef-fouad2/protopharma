// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrugModelAdapter extends TypeAdapter<DrugModel> {
  @override
  final int typeId = 1;

  @override
  DrugModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrugModel(
      commercialNameEn: fields[0] as String,
      scientificName: fields[1] as String,
      manufacturer: fields[2] as String,
      drugClass: fields[3] as String,
      route: fields[4] as String,
      priceEGP: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DrugModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.commercialNameEn)
      ..writeByte(1)
      ..write(obj.scientificName)
      ..writeByte(2)
      ..write(obj.manufacturer)
      ..writeByte(3)
      ..write(obj.drugClass)
      ..writeByte(4)
      ..write(obj.route)
      ..writeByte(5)
      ..write(obj.priceEGP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrugModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
