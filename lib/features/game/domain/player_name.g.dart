// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_name.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerNameAdapter extends TypeAdapter<PlayerName> {
  @override
  final int typeId = 0;

  @override
  PlayerName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerName(
      name: fields[0] as String,
      lastUsed: fields[1] as DateTime,
      usageCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerName obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastUsed)
      ..writeByte(2)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
