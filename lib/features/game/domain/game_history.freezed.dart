// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameHistory _$GameHistoryFromJson(Map<String, dynamic> json) {
  return _GameHistory.fromJson(json);
}

/// @nodoc
mixin _$GameHistory {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get player1Name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get player2Name => throw _privateConstructorUsedError;
  @HiveField(3)
  int get player1FinalScore => throw _privateConstructorUsedError;
  @HiveField(4)
  int get player2FinalScore => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get winnerName =>
      throw _privateConstructorUsedError; // Nullable pour les matchs nuls
  @HiveField(6)
  DateTime get timestamp =>
      throw _privateConstructorUsedError; // Quand la partie s'est terminée
  @HiveField(7)
  List<String> get player1DeckColors =>
      throw _privateConstructorUsedError; // Les 2 couleurs du deck du joueur 1
  @HiveField(8)
  List<String> get player2DeckColors =>
      throw _privateConstructorUsedError; // Les 2 couleurs du deck du joueur 2
  @HiveField(9)
  String? get note =>
      throw _privateConstructorUsedError; // Note sur la partie (optionnel)
  @HiveField(10)
  String? get firstToPlayName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameHistoryCopyWith<GameHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameHistoryCopyWith<$Res> {
  factory $GameHistoryCopyWith(
          GameHistory value, $Res Function(GameHistory) then) =
      _$GameHistoryCopyWithImpl<$Res, GameHistory>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String player1Name,
      @HiveField(2) String player2Name,
      @HiveField(3) int player1FinalScore,
      @HiveField(4) int player2FinalScore,
      @HiveField(5) String? winnerName,
      @HiveField(6) DateTime timestamp,
      @HiveField(7) List<String> player1DeckColors,
      @HiveField(8) List<String> player2DeckColors,
      @HiveField(9) String? note,
      @HiveField(10) String? firstToPlayName});
}

/// @nodoc
class _$GameHistoryCopyWithImpl<$Res, $Val extends GameHistory>
    implements $GameHistoryCopyWith<$Res> {
  _$GameHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1Name = null,
    Object? player2Name = null,
    Object? player1FinalScore = null,
    Object? player2FinalScore = null,
    Object? winnerName = freezed,
    Object? timestamp = null,
    Object? player1DeckColors = null,
    Object? player2DeckColors = null,
    Object? note = freezed,
    Object? firstToPlayName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1Name: null == player1Name
          ? _value.player1Name
          : player1Name // ignore: cast_nullable_to_non_nullable
              as String,
      player2Name: null == player2Name
          ? _value.player2Name
          : player2Name // ignore: cast_nullable_to_non_nullable
              as String,
      player1FinalScore: null == player1FinalScore
          ? _value.player1FinalScore
          : player1FinalScore // ignore: cast_nullable_to_non_nullable
              as int,
      player2FinalScore: null == player2FinalScore
          ? _value.player2FinalScore
          : player2FinalScore // ignore: cast_nullable_to_non_nullable
              as int,
      winnerName: freezed == winnerName
          ? _value.winnerName
          : winnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      player1DeckColors: null == player1DeckColors
          ? _value.player1DeckColors
          : player1DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player2DeckColors: null == player2DeckColors
          ? _value.player2DeckColors
          : player2DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      firstToPlayName: freezed == firstToPlayName
          ? _value.firstToPlayName
          : firstToPlayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameHistoryImplCopyWith<$Res>
    implements $GameHistoryCopyWith<$Res> {
  factory _$$GameHistoryImplCopyWith(
          _$GameHistoryImpl value, $Res Function(_$GameHistoryImpl) then) =
      __$$GameHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String player1Name,
      @HiveField(2) String player2Name,
      @HiveField(3) int player1FinalScore,
      @HiveField(4) int player2FinalScore,
      @HiveField(5) String? winnerName,
      @HiveField(6) DateTime timestamp,
      @HiveField(7) List<String> player1DeckColors,
      @HiveField(8) List<String> player2DeckColors,
      @HiveField(9) String? note,
      @HiveField(10) String? firstToPlayName});
}

/// @nodoc
class __$$GameHistoryImplCopyWithImpl<$Res>
    extends _$GameHistoryCopyWithImpl<$Res, _$GameHistoryImpl>
    implements _$$GameHistoryImplCopyWith<$Res> {
  __$$GameHistoryImplCopyWithImpl(
      _$GameHistoryImpl _value, $Res Function(_$GameHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1Name = null,
    Object? player2Name = null,
    Object? player1FinalScore = null,
    Object? player2FinalScore = null,
    Object? winnerName = freezed,
    Object? timestamp = null,
    Object? player1DeckColors = null,
    Object? player2DeckColors = null,
    Object? note = freezed,
    Object? firstToPlayName = freezed,
  }) {
    return _then(_$GameHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1Name: null == player1Name
          ? _value.player1Name
          : player1Name // ignore: cast_nullable_to_non_nullable
              as String,
      player2Name: null == player2Name
          ? _value.player2Name
          : player2Name // ignore: cast_nullable_to_non_nullable
              as String,
      player1FinalScore: null == player1FinalScore
          ? _value.player1FinalScore
          : player1FinalScore // ignore: cast_nullable_to_non_nullable
              as int,
      player2FinalScore: null == player2FinalScore
          ? _value.player2FinalScore
          : player2FinalScore // ignore: cast_nullable_to_non_nullable
              as int,
      winnerName: freezed == winnerName
          ? _value.winnerName
          : winnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      player1DeckColors: null == player1DeckColors
          ? _value._player1DeckColors
          : player1DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player2DeckColors: null == player2DeckColors
          ? _value._player2DeckColors
          : player2DeckColors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      firstToPlayName: freezed == firstToPlayName
          ? _value.firstToPlayName
          : firstToPlayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameHistoryImpl extends _GameHistory {
  const _$GameHistoryImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.player1Name,
      @HiveField(2) required this.player2Name,
      @HiveField(3) required this.player1FinalScore,
      @HiveField(4) required this.player2FinalScore,
      @HiveField(5) this.winnerName,
      @HiveField(6) required this.timestamp,
      @HiveField(7) final List<String> player1DeckColors = const [],
      @HiveField(8) final List<String> player2DeckColors = const [],
      @HiveField(9) this.note,
      @HiveField(10) this.firstToPlayName})
      : _player1DeckColors = player1DeckColors,
        _player2DeckColors = player2DeckColors,
        super._();

  factory _$GameHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameHistoryImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String player1Name;
  @override
  @HiveField(2)
  final String player2Name;
  @override
  @HiveField(3)
  final int player1FinalScore;
  @override
  @HiveField(4)
  final int player2FinalScore;
  @override
  @HiveField(5)
  final String? winnerName;
// Nullable pour les matchs nuls
  @override
  @HiveField(6)
  final DateTime timestamp;
// Quand la partie s'est terminée
  final List<String> _player1DeckColors;
// Quand la partie s'est terminée
  @override
  @JsonKey()
  @HiveField(7)
  List<String> get player1DeckColors {
    if (_player1DeckColors is EqualUnmodifiableListView)
      return _player1DeckColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_player1DeckColors);
  }

// Les 2 couleurs du deck du joueur 1
  final List<String> _player2DeckColors;
// Les 2 couleurs du deck du joueur 1
  @override
  @JsonKey()
  @HiveField(8)
  List<String> get player2DeckColors {
    if (_player2DeckColors is EqualUnmodifiableListView)
      return _player2DeckColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_player2DeckColors);
  }

// Les 2 couleurs du deck du joueur 2
  @override
  @HiveField(9)
  final String? note;
// Note sur la partie (optionnel)
  @override
  @HiveField(10)
  final String? firstToPlayName;

  @override
  String toString() {
    return 'GameHistory(id: $id, player1Name: $player1Name, player2Name: $player2Name, player1FinalScore: $player1FinalScore, player2FinalScore: $player2FinalScore, winnerName: $winnerName, timestamp: $timestamp, player1DeckColors: $player1DeckColors, player2DeckColors: $player2DeckColors, note: $note, firstToPlayName: $firstToPlayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.player1Name, player1Name) ||
                other.player1Name == player1Name) &&
            (identical(other.player2Name, player2Name) ||
                other.player2Name == player2Name) &&
            (identical(other.player1FinalScore, player1FinalScore) ||
                other.player1FinalScore == player1FinalScore) &&
            (identical(other.player2FinalScore, player2FinalScore) ||
                other.player2FinalScore == player2FinalScore) &&
            (identical(other.winnerName, winnerName) ||
                other.winnerName == winnerName) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._player1DeckColors, _player1DeckColors) &&
            const DeepCollectionEquality()
                .equals(other._player2DeckColors, _player2DeckColors) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.firstToPlayName, firstToPlayName) ||
                other.firstToPlayName == firstToPlayName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      player1Name,
      player2Name,
      player1FinalScore,
      player2FinalScore,
      winnerName,
      timestamp,
      const DeepCollectionEquality().hash(_player1DeckColors),
      const DeepCollectionEquality().hash(_player2DeckColors),
      note,
      firstToPlayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameHistoryImplCopyWith<_$GameHistoryImpl> get copyWith =>
      __$$GameHistoryImplCopyWithImpl<_$GameHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameHistoryImplToJson(
      this,
    );
  }
}

abstract class _GameHistory extends GameHistory {
  const factory _GameHistory(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String player1Name,
      @HiveField(2) required final String player2Name,
      @HiveField(3) required final int player1FinalScore,
      @HiveField(4) required final int player2FinalScore,
      @HiveField(5) final String? winnerName,
      @HiveField(6) required final DateTime timestamp,
      @HiveField(7) final List<String> player1DeckColors,
      @HiveField(8) final List<String> player2DeckColors,
      @HiveField(9) final String? note,
      @HiveField(10) final String? firstToPlayName}) = _$GameHistoryImpl;
  const _GameHistory._() : super._();

  factory _GameHistory.fromJson(Map<String, dynamic> json) =
      _$GameHistoryImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get player1Name;
  @override
  @HiveField(2)
  String get player2Name;
  @override
  @HiveField(3)
  int get player1FinalScore;
  @override
  @HiveField(4)
  int get player2FinalScore;
  @override
  @HiveField(5)
  String? get winnerName;
  @override // Nullable pour les matchs nuls
  @HiveField(6)
  DateTime get timestamp;
  @override // Quand la partie s'est terminée
  @HiveField(7)
  List<String> get player1DeckColors;
  @override // Les 2 couleurs du deck du joueur 1
  @HiveField(8)
  List<String> get player2DeckColors;
  @override // Les 2 couleurs du deck du joueur 2
  @HiveField(9)
  String? get note;
  @override // Note sur la partie (optionnel)
  @HiveField(10)
  String? get firstToPlayName;
  @override
  @JsonKey(ignore: true)
  _$$GameHistoryImplCopyWith<_$GameHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
