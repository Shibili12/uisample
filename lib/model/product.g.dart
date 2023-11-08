// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDbAdapter extends TypeAdapter<ProductDb> {
  @override
  final int typeId = 0;

  @override
  ProductDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDb(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as int,
      isSelected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDb obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
