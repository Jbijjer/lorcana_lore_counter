/// Classe représentant une icône de joueur disponible
class PlayerIcon {
  final String assetPath;
  final String label;

  const PlayerIcon({
    required this.assetPath,
    required this.label,
  });
}

/// Liste des icônes disponibles pour les joueurs
class PlayerIcons {
  static const List<PlayerIcon> availableIcons = [
    PlayerIcon(assetPath: 'assets/images/player_icons/mickey_icon.png', label: 'Mickey'),
    PlayerIcon(assetPath: 'assets/images/player_icons/donald_icon.png', label: 'Donald'),
    PlayerIcon(assetPath: 'assets/images/player_icons/daisy_icon.png', label: 'Daisy'),
    PlayerIcon(assetPath: 'assets/images/player_icons/ariel_icon.png', label: 'Ariel'),
    PlayerIcon(assetPath: 'assets/images/player_icons/aurore_icon.png', label: 'Aurore'),
    PlayerIcon(assetPath: 'assets/images/player_icons/belle_icon.png', label: 'Belle'),
    PlayerIcon(assetPath: 'assets/images/player_icons/beast_icon.png', label: 'Beast'),
    PlayerIcon(assetPath: 'assets/images/player_icons/gaston_icon.png', label: 'Gaston'),
    PlayerIcon(assetPath: 'assets/images/player_icons/lilo_icon.png', label: 'Lilo'),
    PlayerIcon(assetPath: 'assets/images/player_icons/stitch_icon.png', label: 'Stitch'),
    PlayerIcon(assetPath: 'assets/images/player_icons/mufasa_icon.png', label: 'Mufasa'),
    PlayerIcon(assetPath: 'assets/images/player_icons/simba_icon.png', label: 'Simba'),
    PlayerIcon(assetPath: 'assets/images/player_icons/mulan_icon.png', label: 'Mulan'),
  ];

  /// Récupère une icône par son chemin
  static String? getIconByPath(String path) {
    try {
      final icon = availableIcons.firstWhere(
        (icon) => icon.assetPath == path,
        orElse: () => availableIcons[0],
      );
      return icon.assetPath;
    } catch (e) {
      return null;
    }
  }

  /// Icône par défaut
  static const String defaultIcon = 'assets/images/player_icons/mickey_icon.png';
}
