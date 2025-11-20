// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccessibilityPreferencesAdapter
    extends TypeAdapter<AccessibilityPreferences> {
  @override
  final int typeId = 1;

  @override
  AccessibilityPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessibilityPreferences(
      highContrastMode: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AccessibilityPreferences obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.highContrastMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
