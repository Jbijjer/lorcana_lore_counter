// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      id: json['id'] as String,
      player1: Player.fromJson(json['player1'] as Map<String, dynamic>),
      player2: Player.fromJson(json['player2'] as Map<String, dynamic>),
      player1Score: (json['player1Score'] as num?)?.toInt() ?? 0,
      player2Score: (json['player2Score'] as num?)?.toInt() ?? 0,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 1,
      rounds: (json['rounds'] as List<dynamic>?)
              ?.map((e) => RoundScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.inProgress,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player1': instance.player1,
      'player2': instance.player2,
      'player1Score': instance.player1Score,
      'player2Score': instance.player2Score,
      'currentRound': instance.currentRound,
      'rounds': instance.rounds,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$GameStatusEnumMap[instance.status]!,
    };

const _$GameStatusEnumMap = {
  GameStatus.inProgress: 'in_progress',
  GameStatus.finished: 'finished',
  GameStatus.abandoned: 'abandoned',
};

_$RoundScoreImpl _$$RoundScoreImplFromJson(Map<String, dynamic> json) =>
    _$RoundScoreImpl(
      roundNumber: (json['roundNumber'] as num).toInt(),
      player1Delta: (json['player1Delta'] as num).toInt(),
      player2Delta: (json['player2Delta'] as num).toInt(),
      player1TotalScore: (json['player1TotalScore'] as num).toInt(),
      player2TotalScore: (json['player2TotalScore'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$RoundScoreImplToJson(_$RoundScoreImpl instance) =>
    <String, dynamic>{
      'roundNumber': instance.roundNumber,
      'player1Delta': instance.player1Delta,
      'player2Delta': instance.player2Delta,
      'player1TotalScore': instance.player1TotalScore,
      'player2TotalScore': instance.player2TotalScore,
      'timestamp': instance.timestamp.toIso8601String(),
    };
