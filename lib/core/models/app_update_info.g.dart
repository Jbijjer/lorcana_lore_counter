// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUpdateInfoImpl _$$AppUpdateInfoImplFromJson(Map<String, dynamic> json) =>
    _$AppUpdateInfoImpl(
      latestVersion: json['latestVersion'] as String,
      currentVersion: json['currentVersion'] as String,
      downloadUrl: json['downloadUrl'] as String,
      releaseUrl: json['releaseUrl'] as String,
      releaseNotes: json['releaseNotes'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      isUpdateAvailable: json['isUpdateAvailable'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppUpdateInfoImplToJson(_$AppUpdateInfoImpl instance) =>
    <String, dynamic>{
      'latestVersion': instance.latestVersion,
      'currentVersion': instance.currentVersion,
      'downloadUrl': instance.downloadUrl,
      'releaseUrl': instance.releaseUrl,
      'releaseNotes': instance.releaseNotes,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'isUpdateAvailable': instance.isUpdateAvailable,
    };
