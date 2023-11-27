// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderproducts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderproductsAdapter extends TypeAdapter<Orderproducts> {
  @override
  final int typeId = 7;

  @override
  Orderproducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Orderproducts(
      title: fields[1] as String,
      price: fields[2] as int,
      total: fields[3] as String,
      tax: fields[4] as String,
      taxamound: fields[5] as String,
      salesvalue: fields[6] as String,
      qty: fields[7] as String,
      orderid: fields[8] as String,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Orderproducts obj) {
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
      ..write(obj.orderid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderproductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
