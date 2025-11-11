import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thème de l'application basé sur Material 3
class AppTheme {
  const AppTheme._();

  // Couleurs inspirées de Lorcana
  static const Color primaryColor = Color(0xFF6B4EFF); // Violet Lorcana
  static const Color secondaryColor = Color(0xFFFFB800); // Doré
  static const Color amberColor = Color(0xFFFFB800);
  static const Color amethystColor = Color(0xFF9B59B6);
  static const Color emeraldColor = Color(0xFF27AE60);
  static const Color rubyColor = Color(0xFFE74C3C);
  static const Color sapphireColor = Color(0xFF3498DB);
  static const Color steelColor = Color(0xFF95A5A6);

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

    final colorScheme = ColorScheme.light(
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: const Color(0xFFFFD700), // Or vif
      onSecondary: onSurfaceColor,
      error: const Color(0xFFFF0000), // Rouge vif
      onError: onPrimaryColor,
      surfaceContainerHighest: const Color(0xFFE0E0E0), // Gris très clair
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),

      appBarTheme: AppBarTheme(
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

    final colorScheme = ColorScheme.dark(
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: const Color(0xFFFFFF00), // Jaune vif
      onSecondary: onPrimaryColor,
      error: const Color(0xFFFF0000), // Rouge vif
      onError: onSurfaceColor,
      surfaceContainerHighest: const Color(0xFF1A1A1A), // Gris très sombre
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: onSurfaceColor,
        displayColor: onSurfaceColor,
      ),

      appBarTheme: AppBarTheme(
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
    Color(0xFFCC00FF), // Amethyst - magenta vif
    Color(0xFF00FF00), // Emerald - vert vif
    Color(0xFFFF0000), // Ruby - rouge vif
    Color(0xFF0000FF), // Sapphire - bleu vif
    Color(0xFFC0C0C0), // Steel - gris clair vif
  ];
}
