import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thème de l'application basé sur Material 3
class AppTheme {
  const AppTheme._();

  // Couleurs officielles de Lorcana (version vive)
  static const Color primaryColor = Color(0xFF6B4EFF); // Violet Lorcana
  static const Color secondaryColor = Color(0xFFFFC107); // Doré vif
  static const Color amberColor = Color(0xFFFFC107);
  static const Color amethystColor = Color(0xFFAB47BC);
  static const Color emeraldColor = Color(0xFF00E676);
  static const Color rubyColor = Color(0xFFFF1744);
  static const Color sapphireColor = Color(0xFF2196F3);
  static const Color steelColor = Color(0xFFB0BEC5);

  // Couleurs du menu radial (basées sur les couleurs Lorcana)
  static const Color menuStatsColor = sapphireColor; // Bleu Saphir
  static const Color menuDiceColor = amethystColor; // Violet Améthyste
  static const Color menuResetColor = rubyColor; // Rouge Rubis
  static const Color menuTimerColor = amberColor; // Or Ambre
  static const Color menuQuitColor = Color(0xFF6B4EFF); // Violet Lorcana
  static const Color menuSettingsColor = emeraldColor; // Vert Émeraude

  // Couleurs du menu radial (version haut contraste)
  static const Color menuStatsColorHC = Color(0xFF0066FF); // Bleu vif
  static const Color menuDiceColorHC = Color(0xFFE040FB); // Violet vif
  static const Color menuResetColorHC = Color(0xFFFF0000); // Rouge vif
  static const Color menuTimerColorHC = Color(0xFFFFD600); // Or vif
  static const Color menuQuitColorHC = Color(0xFF9B6BFF); // Violet Lorcana vif
  static const Color menuSettingsColorHC = Color(0xFF00FF7F); // Vert vif

  // Couleurs sémantiques
  static const Color successColor = Color(0xFF4CAF50); // Vert
  static const Color warningColor = Color(0xFFFF9800); // Orange
  static const Color errorColor = Color(0xFFF44336); // Rouge
  static const Color infoColor = Color(0xFF2196F3); // Bleu

  // Couleurs de base (pour remplacer Colors.xxx)
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color transparentColor = Color(0x00000000);

  /// Obtient les couleurs du menu radial selon le mode
  static List<Color> getMenuColors({bool highContrast = false}) {
    if (highContrast) {
      return [
        menuStatsColorHC,
        menuDiceColorHC,
        menuResetColorHC,
        menuTimerColorHC,
        menuQuitColorHC,
        menuSettingsColorHC,
      ];
    }
    return [
      menuStatsColor,
      menuDiceColor,
      menuResetColor,
      menuTimerColor,
      menuQuitColor,
      menuSettingsColor,
    ];
  }

  /// Obtient une couleur Lorcana par son nom
  static Color getLorcanaColorByName(String colorName, {bool highContrast = false}) {
    final colors = highContrast ? lorcanaHighContrastColors : lorcanaColors;
    final normalizedName = colorName.toLowerCase().replaceAll('é', 'e');

    switch (normalizedName) {
      case 'amber':
      case 'ambre':
        return colors[0];
      case 'amethyst':
      case 'amethyste':
        return colors[1];
      case 'emerald':
      case 'emeraude':
        return colors[2];
      case 'ruby':
      case 'rubis':
        return colors[3];
      case 'sapphire':
      case 'saphir':
        return colors[4];
      case 'steel':
      case 'acier':
        return colors[5];
      default:
        return colors[0]; // Amber par défaut
    }
  }

  /// Thème clair
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 2,
        color: colorScheme.surfaceBright,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Thème sombre
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        color: colorScheme.surfaceBright,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Couleurs Lorcana pour les joueurs
  static const List<Color> lorcanaColors = [
    amberColor,
    amethystColor,
    emeraldColor,
    rubyColor,
    sapphireColor,
    steelColor,
  ];

  /// Noms des couleurs Lorcana
  static const List<String> lorcanaColorNames = [
    'Amber',
    'Amethyst',
    'Emerald',
    'Ruby',
    'Sapphire',
    'Steel',
  ];

  /// Thème clair à contraste élevé (WCAG AAA)
  static ThemeData get lightHighContrastTheme {
    // Couleurs optimisées pour contraste maximum
    const surfaceColor = Color(0xFFFFFFFF); // Blanc pur
    const onSurfaceColor = Color(0xFF000000); // Noir pur
    const primaryColor = Color(0xFF0000FF); // Bleu vif
    const onPrimaryColor = Color(0xFFFFFFFF); // Blanc pur

    const colorScheme = ColorScheme.light(
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: Color(0xFFFFD700), // Or vif
      onSecondary: onSurfaceColor,
      error: Color(0xFFFF0000), // Rouge vif
      onError: onPrimaryColor,
      surfaceContainerHighest: Color(0xFFE0E0E0), // Gris très clair
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
      ),

      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: onSurfaceColor, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: onSurfaceColor, width: 2),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Thème sombre à contraste élevé (WCAG AAA)
  static ThemeData get darkHighContrastTheme {
    // Couleurs optimisées pour contraste maximum en mode sombre
    const surfaceColor = Color(0xFF000000); // Noir pur
    const onSurfaceColor = Color(0xFFFFFFFF); // Blanc pur
    const primaryColor = Color(0xFF00FFFF); // Cyan vif
    const onPrimaryColor = Color(0xFF000000); // Noir pur

    const colorScheme = ColorScheme.dark(
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: Color(0xFFFFFF00), // Jaune vif
      onSecondary: onPrimaryColor,
      error: Color(0xFFFF0000), // Rouge vif
      onError: onSurfaceColor,
      surfaceContainerHighest: Color(0xFF1A1A1A), // Gris très sombre
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
      ),

      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: onSurfaceColor, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: onSurfaceColor, width: 2),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Couleurs Lorcana pour les joueurs (version contraste élevé)
  static const List<Color> lorcanaHighContrastColors = [
    Color(0xFFFFCC00), // Amber - jaune vif
    Color(0xFFD34EC5), // Amethyst - mauve vif
    Color(0xFF3BDB4D), // Emerald - vert vif
    Color(0xFFFF0000), // Ruby - rouge vif
    Color(0xFF0000FF), // Sapphire - bleu vif
    Color(0xFFC0C0C0), // Steel - gris clair vif
  ];
}
