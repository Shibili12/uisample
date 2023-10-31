// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selectedproduct.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectedproductsAdapter extends TypeAdapter<Selectedproducts> {
  @override
  final int typeId = 2;

  @override
  Selectedproducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Selectedproducts(
      title: fields[1] as String,
      price: fields[2] as int,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Selectedproducts obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedproductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
