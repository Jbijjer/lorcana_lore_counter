import 'package:flutter/material.dart';

/// Classe représentant une icône de joueur disponible
class PlayerIcon {
  final IconData iconData;
  final String label;

  const PlayerIcon({
    required this.iconData,
    required this.label,
  });
}

/// Liste des icônes disponibles pour les joueurs
class PlayerIcons {
  static const List<PlayerIcon> availableIcons = [
    PlayerIcon(iconData: Icons.person, label: 'Personne'),
    PlayerIcon(iconData: Icons.star, label: 'Étoile'),
    PlayerIcon(iconData: Icons.favorite, label: 'Cœur'),
    PlayerIcon(iconData: Icons.emoji_events, label: 'Trophée'),
    PlayerIcon(iconData: Icons.bolt, label: 'Éclair'),
    PlayerIcon(iconData: Icons.auto_awesome, label: 'Magie'),
    PlayerIcon(iconData: Icons.rocket_launch, label: 'Fusée'),
    PlayerIcon(iconData: Icons.shield, label: 'Bouclier'),
    PlayerIcon(iconData: Icons.crown, label: 'Couronne'),
    PlayerIcon(iconData: Icons.local_fire_department, label: 'Feu'),
    PlayerIcon(iconData: Icons.diamond, label: 'Diamant'),
    PlayerIcon(iconData: Icons.pets, label: 'Patte'),
    PlayerIcon(iconData: Icons.sports_esports, label: 'Jeu'),
    PlayerIcon(iconData: Icons.palette, label: 'Palette'),
    PlayerIcon(iconData: Icons.music_note, label: 'Musique'),
    PlayerIcon(iconData: Icons.casino, label: 'Dé'),
    PlayerIcon(iconData: Icons.cake, label: 'Gâteau'),
    PlayerIcon(iconData: Icons.flower, label: 'Fleur'),
    PlayerIcon(iconData: Icons.bug_report, label: 'Insecte'),
    PlayerIcon(iconData: Icons.nightlight, label: 'Lune'),
    PlayerIcon(iconData: Icons.wb_sunny, label: 'Soleil'),
    PlayerIcon(iconData: Icons.ac_unit, label: 'Flocon'),
    PlayerIcon(iconData: Icons.psychology, label: 'Cerveau'),
    PlayerIcon(iconData: Icons.thumb_up, label: 'Pouce levé'),
  ];

  /// Récupère une icône par son codePoint
  static IconData getIconByCodePoint(int codePoint) {
    try {
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      // Retourne l'icône par défaut en cas d'erreur
      return Icons.person;
    }
  }

  /// Icône par défaut
  static const IconData defaultIcon = Icons.person;
}
