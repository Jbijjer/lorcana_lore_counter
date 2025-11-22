// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  String get id => throw _privateConstructorUsedError;
  Player get player1 => throw _privateConstructorUsedError;
  Player get player2 => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  int get player1Score => throw _privateConstructorUsedError;
  int get player2Score => throw _privateConstructorUsedError;
  int get currentRound => throw _privateConstructorUsedError;
  List<RoundScore> get rounds => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  MatchFormat get matchFormat => throw _privateConstructorUsedError;
  int get player1Wins => throw _privateConstructorUsedError;
  int get player2Wins => throw _privateConstructorUsedError;
  bool get player1VictoryDeclined => throw _privateConstructorUsedError;
  bool get player2VictoryDeclined => throw _privateConstructorUsedError;
  int get player1VictoryThreshold => throw _privateConstructorUsedError;
  int get player2VictoryThreshold => throw _privateConstructorUsedError;
  List<String> get player1DeckColors =>
      throw _privateConstructorUsedError; // Les 2 couleurs du deck du joueur 1 pour cette partie
  List<String> get player2DeckColors =>
      throw _privateConstructorUsedError; // Les 2 couleurs du deck du joueur 2 pour cette partie
  bool get isTimeMode =>
      throw _privateConstructorUsedError; // Mode Time activé (fin de temps de jeu)
  int get timeCount =>
      throw _privateConstructorUsedError; // Compteur Time (0 à 5)
  int? get firstToPlay =>
      throw _privateConstructorUsedError; // 1 pour joueur 1, 2 pour joueur 2, null si non défini

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {String id,
      Player player1,
      Player player2,
      DateTime startTime,
      DateTime? endTime,
      int player1Score,
      int player2Score,
      int currentRound,
      List<RoundScore> rounds,
      GameStatus status,
      MatchFormat matchFormat,
      int player1Wins,
      int player2Wins,
      bool player1VictoryDeclined,
      bool player2VictoryDeclined,
      int player1VictoryThreshold,
      int player2VictoryThreshold,
      List<String> player1DeckColors,
      List<String> player2DeckColors,
      bool isTimeMode,
      int timeCount,
      int? firstToPlay});

  $PlayerCopyWith<$Res> get player1;
  $PlayerCopyWith<$Res> get player2;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1 = null,
    Object? player2 = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? player1Score = null,
    Object? player2Score = null,
    Object? currentRound = null,
    Object? rounds = null,
    Object? status = null,
    Object? matchFormat = null,
    Object? player1Wins = null,
    Object? player2Wins = null,
    Object? player1VictoryDeclined = null,
    Object? player2VictoryDeclined = null,
    Object? player1VictoryThreshold = null,
    Object? player2VictoryThreshold = null,
    Object? player1DeckColors = null,
    Object? player2DeckColors = null,
    Object? isTimeMode = null,
    Object? timeCount = null,
    Object? firstToPlay = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1: null == player1
          ? _value.player1
          : player1 // ignore: cast_nullable_to_non_nullable
              as Player,
      player2: null == player2
          ? _value.player2
          : player2 // ignore: cast_nullable_to_non_nullable
              as Player,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      player1Score: null == player1Score
          ? _value.player1Score
          : player1Score // ignore: cast_nullable_to_non_nullable
              as int,
      player2Score: null == player2Score
          ? _value.player2Score
          : player2Score // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      rounds: null == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<RoundScore>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      matchFormat: null == matchFormat
          ? _value.matchFormat
          : matchFormat // ignore: cast_nullable_to_non_nullable
              as MatchFormat,
      player1Wins: null == player1Wins
          ? _value.player1Wins
          : player1Wins // ignore: cast_nullable_to_non_nullable
              as int,
      player2Wins: null == player2Wins
          ? _value.player2Wins
          : player2Wins // ignore: cast_nullable_to_non_nullable
              as int,
      player1VictoryDeclined: null == player1VictoryDeclined
          ? _value.player1VictoryDeclined
          : player1VictoryDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      player2VictoryDeclined: null == player2VictoryDeclined
          ? _value.player2VictoryDeclined
          : player2VictoryDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      player1VictoryThreshold: null == player1VictoryThreshold
          ? _value.player1VictoryThreshold
          : player1VictoryThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      player2VictoryThreshold: null == player2VictoryThreshold
          ? _value.player2VictoryThreshold
          : player2VictoryThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      player1DeckColors: null == player1DeckColors
          ? _value.player1DeckColors
          : player1DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player2DeckColors: null == player2DeckColors
          ? _value.player2DeckColors
          : player2DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTimeMode: null == isTimeMode
          ? _value.isTimeMode
          : isTimeMode // ignore: cast_nullable_to_non_nullable
              as bool,
      timeCount: null == timeCount
          ? _value.timeCount
          : timeCount // ignore: cast_nullable_to_non_nullable
              as int,
      firstToPlay: freezed == firstToPlay
          ? _value.firstToPlay
          : firstToPlay // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player1 {
    return $PlayerCopyWith<$Res>(_value.player1, (value) {
      return _then(_value.copyWith(player1: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player2 {
    return $PlayerCopyWith<$Res>(_value.player2, (value) {
      return _then(_value.copyWith(player2: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Player player1,
      Player player2,
      DateTime startTime,
      DateTime? endTime,
      int player1Score,
      int player2Score,
      int currentRound,
      List<RoundScore> rounds,
      GameStatus status,
      MatchFormat matchFormat,
      int player1Wins,
      int player2Wins,
      bool player1VictoryDeclined,
      bool player2VictoryDeclined,
      int player1VictoryThreshold,
      int player2VictoryThreshold,
      List<String> player1DeckColors,
      List<String> player2DeckColors,
      bool isTimeMode,
      int timeCount,
      int? firstToPlay});

  @override
  $PlayerCopyWith<$Res> get player1;
  @override
  $PlayerCopyWith<$Res> get player2;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1 = null,
    Object? player2 = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? player1Score = null,
    Object? player2Score = null,
    Object? currentRound = null,
    Object? rounds = null,
    Object? status = null,
    Object? matchFormat = null,
    Object? player1Wins = null,
    Object? player2Wins = null,
    Object? player1VictoryDeclined = null,
    Object? player2VictoryDeclined = null,
    Object? player1VictoryThreshold = null,
    Object? player2VictoryThreshold = null,
    Object? player1DeckColors = null,
    Object? player2DeckColors = null,
    Object? isTimeMode = null,
    Object? timeCount = null,
    Object? firstToPlay = freezed,
  }) {
    return _then(_$GameStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1: null == player1
          ? _value.player1
          : player1 // ignore: cast_nullable_to_non_nullable
              as Player,
      player2: null == player2
          ? _value.player2
          : player2 // ignore: cast_nullable_to_non_nullable
              as Player,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      player1Score: null == player1Score
          ? _value.player1Score
          : player1Score // ignore: cast_nullable_to_non_nullable
              as int,
      player2Score: null == player2Score
          ? _value.player2Score
          : player2Score // ignore: cast_nullable_to_non_nullable
              as int,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      rounds: null == rounds
          ? _value._rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as List<RoundScore>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      matchFormat: null == matchFormat
          ? _value.matchFormat
          : matchFormat // ignore: cast_nullable_to_non_nullable
              as MatchFormat,
      player1Wins: null == player1Wins
          ? _value.player1Wins
          : player1Wins // ignore: cast_nullable_to_non_nullable
              as int,
      player2Wins: null == player2Wins
          ? _value.player2Wins
          : player2Wins // ignore: cast_nullable_to_non_nullable
              as int,
      player1VictoryDeclined: null == player1VictoryDeclined
          ? _value.player1VictoryDeclined
          : player1VictoryDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      player2VictoryDeclined: null == player2VictoryDeclined
          ? _value.player2VictoryDeclined
          : player2VictoryDeclined // ignore: cast_nullable_to_non_nullable
              as bool,
      player1VictoryThreshold: null == player1VictoryThreshold
          ? _value.player1VictoryThreshold
          : player1VictoryThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      player2VictoryThreshold: null == player2VictoryThreshold
          ? _value.player2VictoryThreshold
          : player2VictoryThreshold // ignore: cast_nullable_to_non_nullable
              as int,
      player1DeckColors: null == player1DeckColors
          ? _value._player1DeckColors
          : player1DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player2DeckColors: null == player2DeckColors
          ? _value._player2DeckColors
          : player2DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTimeMode: null == isTimeMode
          ? _value.isTimeMode
          : isTimeMode // ignore: cast_nullable_to_non_nullable
              as bool,
      timeCount: null == timeCount
          ? _value.timeCount
          : timeCount // ignore: cast_nullable_to_non_nullable
              as int,
      firstToPlay: freezed == firstToPlay
          ? _value.firstToPlay
          : firstToPlay // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl extends _GameState {
  const _$GameStateImpl(
      {required this.id,
      required this.player1,
      required this.player2,
      required this.startTime,
      this.endTime,
      this.player1Score = 0,
      this.player2Score = 0,
      this.currentRound = 1,
      final List<RoundScore> rounds = const [],
      this.status = GameStatus.inProgress,
      this.matchFormat = MatchFormat.bestOf3,
      this.player1Wins = 0,
      this.player2Wins = 0,
      this.player1VictoryDeclined = false,
      this.player2VictoryDeclined = false,
      this.player1VictoryThreshold = 20,
      this.player2VictoryThreshold = 20,
      final List<String> player1DeckColors = const [],
      final List<String> player2DeckColors = const [],
      this.isTimeMode = false,
      this.timeCount = 5,
      this.firstToPlay})
      : _rounds = rounds,
        _player1DeckColors = player1DeckColors,
        _player2DeckColors = player2DeckColors,
        super._();

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  @override
  final String id;
  @override
  final Player player1;
  @override
  final Player player2;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final int player1Score;
  @override
  @JsonKey()
  final int player2Score;
  @override
  @JsonKey()
  final int currentRound;
  final List<RoundScore> _rounds;
  @override
  @JsonKey()
  List<RoundScore> get rounds {
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rounds);
  }

  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final MatchFormat matchFormat;
  @override
  @JsonKey()
  final int player1Wins;
  @override
  @JsonKey()
  final int player2Wins;
  @override
  @JsonKey()
  final bool player1VictoryDeclined;
  @override
  @JsonKey()
  final bool player2VictoryDeclined;
  @override
  @JsonKey()
  final int player1VictoryThreshold;
  @override
  @JsonKey()
  final int player2VictoryThreshold;
  final List<String> _player1DeckColors;
  @override
  @JsonKey()
  List<String> get player1DeckColors {
    if (_player1DeckColors is EqualUnmodifiableListView)
      return _player1DeckColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_player1DeckColors);
  }

// Les 2 couleurs du deck du joueur 1 pour cette partie
  final List<String> _player2DeckColors;
// Les 2 couleurs du deck du joueur 1 pour cette partie
  @override
  @JsonKey()
  List<String> get player2DeckColors {
    if (_player2DeckColors is EqualUnmodifiableListView)
      return _player2DeckColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_player2DeckColors);
  }

// Mode Time activé (fin de temps de jeu)
  @override
  @JsonKey()
  final bool isTimeMode;
// Compteur Time (0 à 5)
  @override
  @JsonKey()
  final int timeCount;
// 1 pour joueur 1, 2 pour joueur 2, null si non défini
  @override
  final int? firstToPlay;

  @override
  String toString() {
    return 'GameState(id: $id, player1: $player1, player2: $player2, startTime: $startTime, endTime: $endTime, player1Score: $player1Score, player2Score: $player2Score, currentRound: $currentRound, rounds: $rounds, status: $status, matchFormat: $matchFormat, player1Wins: $player1Wins, player2Wins: $player2Wins, player1VictoryDeclined: $player1VictoryDeclined, player2VictoryDeclined: $player2VictoryDeclined, player1VictoryThreshold: $player1VictoryThreshold, player2VictoryThreshold: $player2VictoryThreshold, player1DeckColors: $player1DeckColors, player2DeckColors: $player2DeckColors, isTimeMode: $isTimeMode, timeCount: $timeCount, firstToPlay: $firstToPlay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.player1, player1) || other.player1 == player1) &&
            (identical(other.player2, player2) || other.player2 == player2) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.player1Score, player1Score) ||
                other.player1Score == player1Score) &&
            (identical(other.player2Score, player2Score) ||
                other.player2Score == player2Score) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.matchFormat, matchFormat) ||
                other.matchFormat == matchFormat) &&
            (identical(other.player1Wins, player1Wins) ||
                other.player1Wins == player1Wins) &&
            (identical(other.player2Wins, player2Wins) ||
                other.player2Wins == player2Wins) &&
            (identical(other.player1VictoryDeclined, player1VictoryDeclined) ||
                other.player1VictoryDeclined == player1VictoryDeclined) &&
            (identical(other.player2VictoryDeclined, player2VictoryDeclined) ||
                other.player2VictoryDeclined == player2VictoryDeclined) &&
            (identical(
                    other.player1VictoryThreshold, player1VictoryThreshold) ||
                other.player1VictoryThreshold == player1VictoryThreshold) &&
            (identical(
                    other.player2VictoryThreshold, player2VictoryThreshold) ||
                other.player2VictoryThreshold == player2VictoryThreshold) &&
            const DeepCollectionEquality()
                .equals(other._player1DeckColors, _player1DeckColors) &&
            const DeepCollectionEquality()
                .equals(other._player2DeckColors, _player2DeckColors) &&
            (identical(other.isTimeMode, isTimeMode) ||
                other.isTimeMode == isTimeMode) &&
            (identical(other.timeCount, timeCount) ||
                other.timeCount == timeCount) &&
            (identical(other.firstToPlay, firstToPlay) ||
                other.firstToPlay == firstToPlay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        player1,
        player2,
        startTime,
        endTime,
        player1Score,
        player2Score,
        currentRound,
        const DeepCollectionEquality().hash(_rounds),
        status,
        matchFormat,
        player1Wins,
        player2Wins,
        player1VictoryDeclined,
        player2VictoryDeclined,
        player1VictoryThreshold,
        player2VictoryThreshold,
        const DeepCollectionEquality().hash(_player1DeckColors),
        const DeepCollectionEquality().hash(_player2DeckColors),
        isTimeMode,
        timeCount,
        firstToPlay
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(
      this,
    );
  }
}

abstract class _GameState extends GameState {
  const factory _GameState(
      {required final String id,
      required final Player player1,
      required final Player player2,
      required final DateTime startTime,
      final DateTime? endTime,
      final int player1Score,
      final int player2Score,
      final int currentRound,
      final List<RoundScore> rounds,
      final GameStatus status,
      final MatchFormat matchFormat,
      final int player1Wins,
      final int player2Wins,
      final bool player1VictoryDeclined,
      final bool player2VictoryDeclined,
      final int player1VictoryThreshold,
      final int player2VictoryThreshold,
      final List<String> player1DeckColors,
      final List<String> player2DeckColors,
      final bool isTimeMode,
      final int timeCount,
      final int? firstToPlay}) = _$GameStateImpl;
  const _GameState._() : super._();

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  String get id;
  @override
  Player get player1;
  @override
  Player get player2;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  int get player1Score;
  @override
  int get player2Score;
  @override
  int get currentRound;
  @override
  List<RoundScore> get rounds;
  @override
  GameStatus get status;
  @override
  MatchFormat get matchFormat;
  @override
  int get player1Wins;
  @override
  int get player2Wins;
  @override
  bool get player1VictoryDeclined;
  @override
  bool get player2VictoryDeclined;
  @override
  int get player1VictoryThreshold;
  @override
  int get player2VictoryThreshold;
  @override
  List<String> get player1DeckColors;
  @override // Les 2 couleurs du deck du joueur 1 pour cette partie
  List<String> get player2DeckColors;
  @override // Mode Time activé (fin de temps de jeu)
  bool get isTimeMode;
  @override // Compteur Time (0 à 5)
  int get timeCount;
  @override // 1 pour joueur 1, 2 pour joueur 2, null si non défini
  int? get firstToPlay;
  @override
  @JsonKey(ignore: true)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoundScore _$RoundScoreFromJson(Map<String, dynamic> json) {
  return _RoundScore.fromJson(json);
}

/// @nodoc
mixin _$RoundScore {
  int get roundNumber => throw _privateConstructorUsedError;
  int get player1Delta => throw _privateConstructorUsedError;
  int get player2Delta => throw _privateConstructorUsedError;
  int get player1TotalScore => throw _privateConstructorUsedError;
  int get player2TotalScore => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoundScoreCopyWith<RoundScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundScoreCopyWith<$Res> {
  factory $RoundScoreCopyWith(
          RoundScore value, $Res Function(RoundScore) then) =
      _$RoundScoreCopyWithImpl<$Res, RoundScore>;
  @useResult
  $Res call(
      {int roundNumber,
      int player1Delta,
      int player2Delta,
      int player1TotalScore,
      int player2TotalScore,
      DateTime timestamp});
}

/// @nodoc
class _$RoundScoreCopyWithImpl<$Res, $Val extends RoundScore>
    implements $RoundScoreCopyWith<$Res> {
  _$RoundScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? player1Delta = null,
    Object? player2Delta = null,
    Object? player1TotalScore = null,
    Object? player2TotalScore = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      player1Delta: null == player1Delta
          ? _value.player1Delta
          : player1Delta // ignore: cast_nullable_to_non_nullable
              as int,
      player2Delta: null == player2Delta
          ? _value.player2Delta
          : player2Delta // ignore: cast_nullable_to_non_nullable
              as int,
      player1TotalScore: null == player1TotalScore
          ? _value.player1TotalScore
          : player1TotalScore // ignore: cast_nullable_to_non_nullable
              as int,
      player2TotalScore: null == player2TotalScore
          ? _value.player2TotalScore
          : player2TotalScore // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoundScoreImplCopyWith<$Res>
    implements $RoundScoreCopyWith<$Res> {
  factory _$$RoundScoreImplCopyWith(
          _$RoundScoreImpl value, $Res Function(_$RoundScoreImpl) then) =
      __$$RoundScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int roundNumber,
      int player1Delta,
      int player2Delta,
      int player1TotalScore,
      int player2TotalScore,
      DateTime timestamp});
}

/// @nodoc
class __$$RoundScoreImplCopyWithImpl<$Res>
    extends _$RoundScoreCopyWithImpl<$Res, _$RoundScoreImpl>
    implements _$$RoundScoreImplCopyWith<$Res> {
  __$$RoundScoreImplCopyWithImpl(
      _$RoundScoreImpl _value, $Res Function(_$RoundScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? player1Delta = null,
    Object? player2Delta = null,
    Object? player1TotalScore = null,
    Object? player2TotalScore = null,
    Object? timestamp = null,
  }) {
    return _then(_$RoundScoreImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      player1Delta: null == player1Delta
          ? _value.player1Delta
          : player1Delta // ignore: cast_nullable_to_non_nullable
              as int,
      player2Delta: null == player2Delta
          ? _value.player2Delta
          : player2Delta // ignore: cast_nullable_to_non_nullable
              as int,
      player1TotalScore: null == player1TotalScore
          ? _value.player1TotalScore
          : player1TotalScore // ignore: cast_nullable_to_non_nullable
              as int,
      player2TotalScore: null == player2TotalScore
          ? _value.player2TotalScore
          : player2TotalScore // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundScoreImpl implements _RoundScore {
  const _$RoundScoreImpl(
      {required this.roundNumber,
      required this.player1Delta,
      required this.player2Delta,
      required this.player1TotalScore,
      required this.player2TotalScore,
      required this.timestamp});

  factory _$RoundScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundScoreImplFromJson(json);

  @override
  final int roundNumber;
  @override
  final int player1Delta;
  @override
  final int player2Delta;
  @override
  final int player1TotalScore;
  @override
  final int player2TotalScore;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'RoundScore(roundNumber: $roundNumber, player1Delta: $player1Delta, player2Delta: $player2Delta, player1TotalScore: $player1TotalScore, player2TotalScore: $player2TotalScore, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundScoreImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.player1Delta, player1Delta) ||
                other.player1Delta == player1Delta) &&
            (identical(other.player2Delta, player2Delta) ||
                other.player2Delta == player2Delta) &&
            (identical(other.player1TotalScore, player1TotalScore) ||
                other.player1TotalScore == player1TotalScore) &&
            (identical(other.player2TotalScore, player2TotalScore) ||
                other.player2TotalScore == player2TotalScore) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, roundNumber, player1Delta,
      player2Delta, player1TotalScore, player2TotalScore, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundScoreImplCopyWith<_$RoundScoreImpl> get copyWith =>
      __$$RoundScoreImplCopyWithImpl<_$RoundScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundScoreImplToJson(
      this,
    );
  }
}

abstract class _RoundScore implements RoundScore {
  const factory _RoundScore(
      {required final int roundNumber,
      required final int player1Delta,
      required final int player2Delta,
      required final int player1TotalScore,
      required final int player2TotalScore,
      required final DateTime timestamp}) = _$RoundScoreImpl;

  factory _RoundScore.fromJson(Map<String, dynamic> json) =
      _$RoundScoreImpl.fromJson;

  @override
  int get roundNumber;
  @override
  int get player1Delta;
  @override
  int get player2Delta;
  @override
  int get player1TotalScore;
  @override
  int get player2TotalScore;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$RoundScoreImplCopyWith<_$RoundScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
