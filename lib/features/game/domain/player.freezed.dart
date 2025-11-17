// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get color => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get backgroundColorStart => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get backgroundColorEnd => throw _privateConstructorUsedError;
  int get iconCodePoint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color color,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color backgroundColorStart,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color backgroundColorEnd,
      int iconCodePoint});
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? backgroundColorStart = null,
    Object? backgroundColorEnd = null,
    Object? iconCodePoint = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColorStart: null == backgroundColorStart
          ? _value.backgroundColorStart
          : backgroundColorStart // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColorEnd: null == backgroundColorEnd
          ? _value.backgroundColorEnd
          : backgroundColorEnd // ignore: cast_nullable_to_non_nullable
              as Color,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
          _$PlayerImpl value, $Res Function(_$PlayerImpl) then) =
      __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color color,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color backgroundColorStart,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      Color backgroundColorEnd,
      int iconCodePoint});
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
      _$PlayerImpl _value, $Res Function(_$PlayerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? backgroundColorStart = null,
    Object? backgroundColorEnd = null,
    Object? iconCodePoint = null,
  }) {
    return _then(_$PlayerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColorStart: null == backgroundColorStart
          ? _value.backgroundColorStart
          : backgroundColorStart // ignore: cast_nullable_to_non_nullable
              as Color,
      backgroundColorEnd: null == backgroundColorEnd
          ? _value.backgroundColorEnd
          : backgroundColorEnd // ignore: cast_nullable_to_non_nullable
              as Color,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl implements _Player {
  const _$PlayerImpl(
      {required this.id,
      required this.name,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.color,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.backgroundColorStart,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.backgroundColorEnd,
      this.iconCodePoint = 0xe491});

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color backgroundColorStart;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color backgroundColorEnd;
  @override
  @JsonKey()
  final int iconCodePoint;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, color: $color, backgroundColorStart: $backgroundColorStart, backgroundColorEnd: $backgroundColorEnd, iconCodePoint: $iconCodePoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.backgroundColorStart, backgroundColorStart) ||
                other.backgroundColorStart == backgroundColorStart) &&
            (identical(other.backgroundColorEnd, backgroundColorEnd) ||
                other.backgroundColorEnd == backgroundColorEnd) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color,
      backgroundColorStart, backgroundColorEnd, iconCodePoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(
      this,
    );
  }
}

abstract class _Player implements Player {
  const factory _Player(
      {required final String id,
      required final String name,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required final Color color,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required final Color backgroundColorStart,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required final Color backgroundColorEnd,
      final int iconCodePoint}) = _$PlayerImpl;

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get color;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get backgroundColorStart;
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get backgroundColorEnd;
  @override
  int get iconCodePoint;
  @override
  @JsonKey(ignore: true)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
