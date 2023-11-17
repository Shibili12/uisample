// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaints.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComplaintAdapter extends TypeAdapter<Complaint> {
  @override
  final int typeId = 4;

  @override
  Complaint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Complaint(
      primarynumber: fields[0] as String,
      name: fields[1] as String,
      secondarynumber: fields[2] as String,
      whatsappnumber: fields[3] as String,
      outsidemob: fields[4] as String,
      followdate: fields[5] as String,
      followtime: fields[6] as String,
      expclosure: fields[7] as String,
      source: fields[8] as String,
      assigneduser: fields[9] as String,
      taguser: fields[10] as String,
      location: fields[11] as String,
      referedby: fields[12] as String,
      email: fields[13] as String,
      remarks: fields[15] as String,
      audiopath: fields[16] as String?,
      mediapath: (fields[17] as List?)?.cast<String>(),
    )..id = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, Complaint obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.primarynumber)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.secondarynumber)
      ..writeByte(3)
      ..write(obj.whatsappnumber)
      ..writeByte(4)
      ..write(obj.outsidemob)
      ..writeByte(5)
      ..write(obj.followdate)
      ..writeByte(6)
      ..write(obj.followtime)
      ..writeByte(7)
      ..write(obj.expclosure)
      ..writeByte(8)
      ..write(obj.source)
      ..writeByte(9)
      ..write(obj.assigneduser)
      ..writeByte(10)
      ..write(obj.taguser)
      ..writeByte(11)
      ..write(obj.location)
      ..writeByte(12)
      ..write(obj.referedby)
      ..writeByte(13)
      ..write(obj.email)
      ..writeByte(14)
      ..write(obj.id)
      ..writeByte(15)
      ..write(obj.remarks)
      ..writeByte(16)
      ..write(obj.audiopath)
      ..writeByte(17)
      ..write(obj.mediapath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplaintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
