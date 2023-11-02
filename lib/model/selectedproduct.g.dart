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
      total: fields[3] as String,
      tax: fields[4] as String,
      taxamound: fields[5] as String,
      salesvalue: fields[6] as String,
      qty: fields[7] as String,
      enquiryId: fields[8] as String,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Selectedproducts obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.tax)
      ..writeByte(5)
      ..write(obj.taxamound)
      ..writeByte(6)
      ..write(obj.salesvalue)
      ..writeByte(7)
      ..write(obj.qty)
      ..writeByte(8)
      ..write(obj.enquiryId);
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
