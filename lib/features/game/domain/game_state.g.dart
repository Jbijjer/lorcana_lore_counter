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
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      player1Score: (json['player1Score'] as num?)?.toInt() ?? 0,
      player2Score: (json['player2Score'] as num?)?.toInt() ?? 0,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 1,
      rounds: (json['rounds'] as List<dynamic>?)
              ?.map((e) => RoundScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.inProgress,
      matchFormat:
          $enumDecodeNullable(_$MatchFormatEnumMap, json['matchFormat']) ??
              MatchFormat.bestOf3,
      player1Wins: (json['player1Wins'] as num?)?.toInt() ?? 0,
      player2Wins: (json['player2Wins'] as num?)?.toInt() ?? 0,
      player1VictoryDeclined: json['player1VictoryDeclined'] as bool? ?? false,
      player2VictoryDeclined: json['player2VictoryDeclined'] as bool? ?? false,
      player1VictoryThreshold:
          (json['player1VictoryThreshold'] as num?)?.toInt() ?? 20,
      player2VictoryThreshold:
          (json['player2VictoryThreshold'] as num?)?.toInt() ?? 20,
      player1DeckColors: (json['player1DeckColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      player2DeckColors: (json['player2DeckColors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player1': instance.player1,
      'player2': instance.player2,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'player1Score': instance.player1Score,
      'player2Score': instance.player2Score,
      'currentRound': instance.currentRound,
      'rounds': instance.rounds,
      'status': _$GameStatusEnumMap[instance.status]!,
      'matchFormat': _$MatchFormatEnumMap[instance.matchFormat]!,
      'player1Wins': instance.player1Wins,
      'player2Wins': instance.player2Wins,
      'player1VictoryDeclined': instance.player1VictoryDeclined,
      'player2VictoryDeclined': instance.player2VictoryDeclined,
      'player1VictoryThreshold': instance.player1VictoryThreshold,
      'player2VictoryThreshold': instance.player2VictoryThreshold,
      'player1DeckColors': instance.player1DeckColors,
      'player2DeckColors': instance.player2DeckColors,
    };

const _$GameStatusEnumMap = {
  GameStatus.inProgress: 'in_progress',
  GameStatus.finished: 'finished',
  GameStatus.abandoned: 'abandoned',
};

const _$MatchFormatEnumMap = {
  MatchFormat.bestOf1: 'best_of_1',
  MatchFormat.bestOf3: 'best_of_3',
  MatchFormat.bestOf5: 'best_of_5',
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
