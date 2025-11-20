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
      backgroundColorStartValue: fields[3] as int?,
      backgroundColorEndValue: fields[4] as int?,
      iconCodePoint: fields[5] as int?,
      id: fields[6] as String?,
      iconAssetPath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerName obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastUsed)
      ..writeByte(2)
      ..write(obj.usageCount)
      ..writeByte(3)
      ..write(obj.backgroundColorStartValue)
      ..writeByte(4)
      ..write(obj.backgroundColorEndValue)
      ..writeByte(5)
      ..write(obj.iconCodePoint)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.iconAssetPath);
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
