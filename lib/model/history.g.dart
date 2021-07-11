// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 0;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      cardType: fields[3] as String,
      type: fields[0] as int,
      attr: fields[4] as String,
      name: fields[5] as String,
      image: fields[6] as String,
      base64Image: fields[7] as String,
      trapSpellType: fields[8] as String?,
      nameType: fields[9] as String,
      desc: fields[10] as String,
      serialNumber: fields[1] as int,
      level: fields[2] as int,
      year: fields[11] as String,
      atk: fields[12] as String,
      def: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.serialNumber)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.cardType)
      ..writeByte(4)
      ..write(obj.attr)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.base64Image)
      ..writeByte(8)
      ..write(obj.trapSpellType)
      ..writeByte(9)
      ..write(obj.nameType)
      ..writeByte(10)
      ..write(obj.desc)
      ..writeByte(11)
      ..write(obj.year)
      ..writeByte(12)
      ..write(obj.atk)
      ..writeByte(13)
      ..write(obj.def);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
