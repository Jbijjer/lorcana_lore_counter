// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameHistoryAdapter extends TypeAdapter<GameHistory> {
  @override
  final int typeId = 2;

  @override
  GameHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameHistory(
      id: fields[0] as String,
      player1Name: fields[1] as String,
      player2Name: fields[2] as String,
      player1FinalScore: fields[3] as int,
      player2FinalScore: fields[4] as int,
      winnerName: fields[5] as String?,
      timestamp: fields[6] as DateTime,
      player1DeckColors: (fields[7] as List).cast<String>(),
      player2DeckColors: (fields[8] as List).cast<String>(),
      note: fields[9] as String?,
      firstToPlayName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GameHistory obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.player1Name)
      ..writeByte(2)
      ..write(obj.player2Name)
      ..writeByte(3)
      ..write(obj.player1FinalScore)
      ..writeByte(4)
      ..write(obj.player2FinalScore)
      ..writeByte(5)
      ..write(obj.winnerName)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.player1DeckColors)
      ..writeByte(8)
      ..write(obj.player2DeckColors)
      ..writeByte(9)
      ..write(obj.note)
      ..writeByte(10)
      ..write(obj.firstToPlayName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameHistoryImpl _$$GameHistoryImplFromJson(Map<String, dynamic> json) =>
    _$GameHistoryImpl(
      id: json['id'] as String,
      player1Name: json['player1Name'] as String,
      player2Name: json['player2Name'] as String,
      player1FinalScore: (json['player1FinalScore'] as num).toInt(),
      player2FinalScore: (json['player2FinalScore'] as num).toInt(),
      winnerName: json['winnerName'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      player1DeckColors: (json['player1DeckColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      player2DeckColors: (json['player2DeckColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      note: json['note'] as String?,
      firstToPlayName: json['firstToPlayName'] as String?,
    );

Map<String, dynamic> _$$GameHistoryImplToJson(_$GameHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player1Name': instance.player1Name,
      'player2Name': instance.player2Name,
      'player1FinalScore': instance.player1FinalScore,
      'player2FinalScore': instance.player2FinalScore,
      'winnerName': instance.winnerName,
      'timestamp': instance.timestamp.toIso8601String(),
      'player1DeckColors': instance.player1DeckColors,
      'player2DeckColors': instance.player2DeckColors,
      'note': instance.note,
      'firstToPlayName': instance.firstToPlayName,
    };
