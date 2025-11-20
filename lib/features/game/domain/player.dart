import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/player_icons.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// Modèle représentant un joueur
@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color color,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color backgroundColorStart,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color backgroundColorEnd,
    @Default('assets/images/player_icons/mickey_icon.png') String iconAssetPath,
    @Default([]) List<String> deckColors, // Les 2 couleurs du deck (Amber, Amethyst, Emerald, Ruby, Sapphire, Steel)
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Crée un nouveau joueur
  factory Player.create({
    required String name,
    required Color color,
    Color? backgroundColorStart,
    Color? backgroundColorEnd,
    String? iconAssetPath,
  }) {
    return Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      color: color,
      backgroundColorStart: backgroundColorStart ?? color,
      backgroundColorEnd: backgroundColorEnd ?? color,
      iconAssetPath: iconAssetPath ?? PlayerIcons.defaultIcon,
    );
  }
}

/// Convertir une couleur depuis JSON
Color _colorFromJson(int value) => Color(value);

/// Convertir une couleur vers JSON
int _colorToJson(Color color) => color.toARGB32();
