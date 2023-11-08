// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientDbAdapter extends TypeAdapter<ClientDb> {
  @override
  final int typeId = 3;

  @override
  ClientDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientDb(
      name: fields[0] as String,
      phonenumber: fields[1] as String,
      place: fields[3] as String,
      email: fields[2] as String,
      secondarynumber: fields[4] as String,
    )..id = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ClientDb obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phonenumber)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.place)
      ..writeByte(4)
      ..write(obj.secondarynumber)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
