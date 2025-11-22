import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_info.freezed.dart';
part 'app_update_info.g.dart';

/// Informations sur une mise à jour disponible
@freezed
class AppUpdateInfo with _$AppUpdateInfo {
  const factory AppUpdateInfo({
    /// Version disponible (ex: "1.2.0")
    required String latestVersion,

    /// Version actuelle de l'app
    required String currentVersion,

    /// URL de téléchargement de la release
    required String downloadUrl,

    /// URL de la page de release sur GitHub
    required String releaseUrl,

    /// Notes de release (changelog)
    String? releaseNotes,

    /// Date de publication
    DateTime? publishedAt,

    /// Indique si une mise à jour est disponible
    @Default(false) bool isUpdateAvailable,
  }) = _AppUpdateInfo;

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateInfoFromJson(json);
}

/// État de la vérification des mises à jour
@freezed
class UpdateCheckState with _$UpdateCheckState {
  /// État initial, non vérifié
  const factory UpdateCheckState.initial() = _Initial;

  /// Vérification en cours
  const factory UpdateCheckState.checking() = _Checking;

  /// Mise à jour disponible
  const factory UpdateCheckState.updateAvailable(AppUpdateInfo info) = _UpdateAvailable;

  /// Application à jour
  const factory UpdateCheckState.upToDate(String currentVersion) = _UpToDate;

  /// Erreur lors de la vérification
  const factory UpdateCheckState.error(String message) = _Error;
}
