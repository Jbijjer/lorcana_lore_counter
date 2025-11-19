// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: _colorFromJson((json['color'] as num).toInt()),
      backgroundColorStart:
          _colorFromJson((json['backgroundColorStart'] as num).toInt()),
      backgroundColorEnd:
          _colorFromJson((json['backgroundColorEnd'] as num).toInt()),
      iconAssetPath: json['iconAssetPath'] as String? ??
          'assets/images/player_icons/mickey_icon.png',
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': _colorToJson(instance.color),
      'backgroundColorStart': _colorToJson(instance.backgroundColorStart),
      'backgroundColorEnd': _colorToJson(instance.backgroundColorEnd),
      'iconAssetPath': instance.iconAssetPath,
    };
