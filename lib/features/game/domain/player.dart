import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

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
    @Default(0) int gamesPlayed,
    @Default(0) int gamesWon,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Crée un nouveau joueur
  factory Player.create({
    required String name,
    required Color color,
    Color? backgroundColorStart,
    Color? backgroundColorEnd,
  }) {
    return Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      color: color,
      backgroundColorStart: backgroundColorStart ?? color,
      backgroundColorEnd: backgroundColorEnd ?? color,
    );
  }
}

/// Convertir une couleur depuis JSON
Color _colorFromJson(int value) => Color(value);

/// Convertir une couleur vers JSON
int _colorToJson(Color color) => color.value;
