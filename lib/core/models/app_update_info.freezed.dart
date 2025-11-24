// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUpdateInfo _$AppUpdateInfoFromJson(Map<String, dynamic> json) {
  return _AppUpdateInfo.fromJson(json);
}

/// @nodoc
mixin _$AppUpdateInfo {
  /// Version disponible (ex: "1.2.0")
  String get latestVersion => throw _privateConstructorUsedError;

  /// Version actuelle de l'app
  String get currentVersion => throw _privateConstructorUsedError;

  /// URL de téléchargement de la release
  String get downloadUrl => throw _privateConstructorUsedError;

  /// URL de la page de release sur GitHub
  String get releaseUrl => throw _privateConstructorUsedError;

  /// Notes de release (changelog)
  String? get releaseNotes => throw _privateConstructorUsedError;

  /// Date de publication
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  /// Indique si une mise à jour est disponible
  bool get isUpdateAvailable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppUpdateInfoCopyWith<AppUpdateInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUpdateInfoCopyWith<$Res> {
  factory $AppUpdateInfoCopyWith(
          AppUpdateInfo value, $Res Function(AppUpdateInfo) then) =
      _$AppUpdateInfoCopyWithImpl<$Res, AppUpdateInfo>;
  @useResult
  $Res call(
      {String latestVersion,
      String currentVersion,
      String downloadUrl,
      String releaseUrl,
      String? releaseNotes,
      DateTime? publishedAt,
      bool isUpdateAvailable});
}

/// @nodoc
class _$AppUpdateInfoCopyWithImpl<$Res, $Val extends AppUpdateInfo>
    implements $AppUpdateInfoCopyWith<$Res> {
  _$AppUpdateInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? currentVersion = null,
    Object? downloadUrl = null,
    Object? releaseUrl = null,
    Object? releaseNotes = freezed,
    Object? publishedAt = freezed,
    Object? isUpdateAvailable = null,
  }) {
    return _then(_value.copyWith(
      latestVersion: null == latestVersion
          ? _value.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as String,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      releaseUrl: null == releaseUrl
          ? _value.releaseUrl
          : releaseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      releaseNotes: freezed == releaseNotes
          ? _value.releaseNotes
          : releaseNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUpdateAvailable: null == isUpdateAvailable
          ? _value.isUpdateAvailable
          : isUpdateAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUpdateInfoImplCopyWith<$Res>
    implements $AppUpdateInfoCopyWith<$Res> {
  factory _$$AppUpdateInfoImplCopyWith(
          _$AppUpdateInfoImpl value, $Res Function(_$AppUpdateInfoImpl) then) =
      __$$AppUpdateInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String latestVersion,
      String currentVersion,
      String downloadUrl,
      String releaseUrl,
      String? releaseNotes,
      DateTime? publishedAt,
      bool isUpdateAvailable});
}

/// @nodoc
class __$$AppUpdateInfoImplCopyWithImpl<$Res>
    extends _$AppUpdateInfoCopyWithImpl<$Res, _$AppUpdateInfoImpl>
    implements _$$AppUpdateInfoImplCopyWith<$Res> {
  __$$AppUpdateInfoImplCopyWithImpl(
      _$AppUpdateInfoImpl _value, $Res Function(_$AppUpdateInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = null,
    Object? currentVersion = null,
    Object? downloadUrl = null,
    Object? releaseUrl = null,
    Object? releaseNotes = freezed,
    Object? publishedAt = freezed,
    Object? isUpdateAvailable = null,
  }) {
    return _then(_$AppUpdateInfoImpl(
      latestVersion: null == latestVersion
          ? _value.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as String,
      currentVersion: null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as String,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      releaseUrl: null == releaseUrl
          ? _value.releaseUrl
          : releaseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      releaseNotes: freezed == releaseNotes
          ? _value.releaseNotes
          : releaseNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isUpdateAvailable: null == isUpdateAvailable
          ? _value.isUpdateAvailable
          : isUpdateAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUpdateInfoImpl implements _AppUpdateInfo {
  const _$AppUpdateInfoImpl(
      {required this.latestVersion,
      required this.currentVersion,
      required this.downloadUrl,
      required this.releaseUrl,
      this.releaseNotes,
      this.publishedAt,
      this.isUpdateAvailable = false});

  factory _$AppUpdateInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUpdateInfoImplFromJson(json);

  /// Version disponible (ex: "1.2.0")
  @override
  final String latestVersion;

  /// Version actuelle de l'app
  @override
  final String currentVersion;

  /// URL de téléchargement de la release
  @override
  final String downloadUrl;

  /// URL de la page de release sur GitHub
  @override
  final String releaseUrl;

  /// Notes de release (changelog)
  @override
  final String? releaseNotes;

  /// Date de publication
  @override
  final DateTime? publishedAt;

  /// Indique si une mise à jour est disponible
  @override
  @JsonKey()
  final bool isUpdateAvailable;

  @override
  String toString() {
    return 'AppUpdateInfo(latestVersion: $latestVersion, currentVersion: $currentVersion, downloadUrl: $downloadUrl, releaseUrl: $releaseUrl, releaseNotes: $releaseNotes, publishedAt: $publishedAt, isUpdateAvailable: $isUpdateAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUpdateInfoImpl &&
            (identical(other.latestVersion, latestVersion) ||
                other.latestVersion == latestVersion) &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.releaseUrl, releaseUrl) ||
                other.releaseUrl == releaseUrl) &&
            (identical(other.releaseNotes, releaseNotes) ||
                other.releaseNotes == releaseNotes) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.isUpdateAvailable, isUpdateAvailable) ||
                other.isUpdateAvailable == isUpdateAvailable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latestVersion, currentVersion,
      downloadUrl, releaseUrl, releaseNotes, publishedAt, isUpdateAvailable);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUpdateInfoImplCopyWith<_$AppUpdateInfoImpl> get copyWith =>
      __$$AppUpdateInfoImplCopyWithImpl<_$AppUpdateInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUpdateInfoImplToJson(
      this,
    );
  }
}

abstract class _AppUpdateInfo implements AppUpdateInfo {
  const factory _AppUpdateInfo(
      {required final String latestVersion,
      required final String currentVersion,
      required final String downloadUrl,
      required final String releaseUrl,
      final String? releaseNotes,
      final DateTime? publishedAt,
      final bool isUpdateAvailable}) = _$AppUpdateInfoImpl;

  factory _AppUpdateInfo.fromJson(Map<String, dynamic> json) =
      _$AppUpdateInfoImpl.fromJson;

  @override

  /// Version disponible (ex: "1.2.0")
  String get latestVersion;
  @override

  /// Version actuelle de l'app
  String get currentVersion;
  @override

  /// URL de téléchargement de la release
  String get downloadUrl;
  @override

  /// URL de la page de release sur GitHub
  String get releaseUrl;
  @override

  /// Notes de release (changelog)
  String? get releaseNotes;
  @override

  /// Date de publication
  DateTime? get publishedAt;
  @override

  /// Indique si une mise à jour est disponible
  bool get isUpdateAvailable;
  @override
  @JsonKey(ignore: true)
  _$$AppUpdateInfoImplCopyWith<_$AppUpdateInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateCheckState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCheckStateCopyWith<$Res> {
  factory $UpdateCheckStateCopyWith(
          UpdateCheckState value, $Res Function(UpdateCheckState) then) =
      _$UpdateCheckStateCopyWithImpl<$Res, UpdateCheckState>;
}

/// @nodoc
class _$UpdateCheckStateCopyWithImpl<$Res, $Val extends UpdateCheckState>
    implements $UpdateCheckStateCopyWith<$Res> {
  _$UpdateCheckStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$UpdateCheckStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'UpdateCheckState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements UpdateCheckState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$CheckingImplCopyWith<$Res> {
  factory _$$CheckingImplCopyWith(
          _$CheckingImpl value, $Res Function(_$CheckingImpl) then) =
      __$$CheckingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckingImplCopyWithImpl<$Res>
    extends _$UpdateCheckStateCopyWithImpl<$Res, _$CheckingImpl>
    implements _$$CheckingImplCopyWith<$Res> {
  __$$CheckingImplCopyWithImpl(
      _$CheckingImpl _value, $Res Function(_$CheckingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CheckingImpl implements _Checking {
  const _$CheckingImpl();

  @override
  String toString() {
    return 'UpdateCheckState.checking()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return checking();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return checking?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) {
    return checking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) {
    return checking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (checking != null) {
      return checking(this);
    }
    return orElse();
  }
}

abstract class _Checking implements UpdateCheckState {
  const factory _Checking() = _$CheckingImpl;
}

/// @nodoc
abstract class _$$UpdateAvailableImplCopyWith<$Res> {
  factory _$$UpdateAvailableImplCopyWith(_$UpdateAvailableImpl value,
          $Res Function(_$UpdateAvailableImpl) then) =
      __$$UpdateAvailableImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppUpdateInfo info});

  $AppUpdateInfoCopyWith<$Res> get info;
}

/// @nodoc
class __$$UpdateAvailableImplCopyWithImpl<$Res>
    extends _$UpdateCheckStateCopyWithImpl<$Res, _$UpdateAvailableImpl>
    implements _$$UpdateAvailableImplCopyWith<$Res> {
  __$$UpdateAvailableImplCopyWithImpl(
      _$UpdateAvailableImpl _value, $Res Function(_$UpdateAvailableImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
  }) {
    return _then(_$UpdateAvailableImpl(
      null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as AppUpdateInfo,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AppUpdateInfoCopyWith<$Res> get info {
    return $AppUpdateInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value));
    });
  }
}

/// @nodoc

class _$UpdateAvailableImpl implements _UpdateAvailable {
  const _$UpdateAvailableImpl(this.info);

  @override
  final AppUpdateInfo info;

  @override
  String toString() {
    return 'UpdateCheckState.updateAvailable(info: $info)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAvailableImpl &&
            (identical(other.info, info) || other.info == info));
  }

  @override
  int get hashCode => Object.hash(runtimeType, info);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAvailableImplCopyWith<_$UpdateAvailableImpl> get copyWith =>
      __$$UpdateAvailableImplCopyWithImpl<_$UpdateAvailableImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return updateAvailable(info);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return updateAvailable?.call(info);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (updateAvailable != null) {
      return updateAvailable(info);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) {
    return updateAvailable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) {
    return updateAvailable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (updateAvailable != null) {
      return updateAvailable(this);
    }
    return orElse();
  }
}

abstract class _UpdateAvailable implements UpdateCheckState {
  const factory _UpdateAvailable(final AppUpdateInfo info) =
      _$UpdateAvailableImpl;

  AppUpdateInfo get info;
  @JsonKey(ignore: true)
  _$$UpdateAvailableImplCopyWith<_$UpdateAvailableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpToDateImplCopyWith<$Res> {
  factory _$$UpToDateImplCopyWith(
          _$UpToDateImpl value, $Res Function(_$UpToDateImpl) then) =
      __$$UpToDateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currentVersion});
}

/// @nodoc
class __$$UpToDateImplCopyWithImpl<$Res>
    extends _$UpdateCheckStateCopyWithImpl<$Res, _$UpToDateImpl>
    implements _$$UpToDateImplCopyWith<$Res> {
  __$$UpToDateImplCopyWithImpl(
      _$UpToDateImpl _value, $Res Function(_$UpToDateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentVersion = null,
  }) {
    return _then(_$UpToDateImpl(
      null == currentVersion
          ? _value.currentVersion
          : currentVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UpToDateImpl implements _UpToDate {
  const _$UpToDateImpl(this.currentVersion);

  @override
  final String currentVersion;

  @override
  String toString() {
    return 'UpdateCheckState.upToDate(currentVersion: $currentVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpToDateImpl &&
            (identical(other.currentVersion, currentVersion) ||
                other.currentVersion == currentVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpToDateImplCopyWith<_$UpToDateImpl> get copyWith =>
      __$$UpToDateImplCopyWithImpl<_$UpToDateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return upToDate(currentVersion);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return upToDate?.call(currentVersion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (upToDate != null) {
      return upToDate(currentVersion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) {
    return upToDate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) {
    return upToDate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (upToDate != null) {
      return upToDate(this);
    }
    return orElse();
  }
}

abstract class _UpToDate implements UpdateCheckState {
  const factory _UpToDate(final String currentVersion) = _$UpToDateImpl;

  String get currentVersion;
  @JsonKey(ignore: true)
  _$$UpToDateImplCopyWith<_$UpToDateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$UpdateCheckStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UpdateCheckState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() checking,
    required TResult Function(AppUpdateInfo info) updateAvailable,
    required TResult Function(String currentVersion) upToDate,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? checking,
    TResult? Function(AppUpdateInfo info)? updateAvailable,
    TResult? Function(String currentVersion)? upToDate,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? checking,
    TResult Function(AppUpdateInfo info)? updateAvailable,
    TResult Function(String currentVersion)? upToDate,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Checking value) checking,
    required TResult Function(_UpdateAvailable value) updateAvailable,
    required TResult Function(_UpToDate value) upToDate,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Checking value)? checking,
    TResult? Function(_UpdateAvailable value)? updateAvailable,
    TResult? Function(_UpToDate value)? upToDate,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Checking value)? checking,
    TResult Function(_UpdateAvailable value)? updateAvailable,
    TResult Function(_UpToDate value)? upToDate,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements UpdateCheckState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
