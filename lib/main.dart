import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/models/accessibility_preferences.dart';
import 'core/providers/accessibility_provider.dart';
import 'features/game/presentation/screens/play_screen.dart';
import 'features/game/data/player_history_service.dart';
import 'features/game/data/game_persistence_service.dart';
import 'features/game/data/game_statistics_service.dart';
import 'features/game/domain/game_history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive
  await Hive.initFlutter();

  // Enregistrer les adaptateurs Hive
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AccessibilityPreferencesAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(GameHistoryAdapter());
  }

  // Créer le container de providers
  final container = ProviderContainer();

  // Initialiser le service d'historique des joueurs
  await container.read(playerHistoryServiceProvider).init();

  // Initialiser le service de persistence du jeu
  await container.read(gamePersistenceServiceProvider).init();

  // Initialiser le service de statistiques
  await container.read(gameStatisticsServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LorcanaScoreKeeperApp(),
    ),
  );
}

/// Application principale
class LorcanaScoreKeeperApp extends ConsumerWidget {
  const LorcanaScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityPrefs = ref.watch(accessibilityNotifierProvider);

    return accessibilityPrefs.when(
      data: (prefs) {
        final ThemeData lightTheme = prefs.highContrastMode
            ? AppTheme.lightHighContrastTheme
            : AppTheme.lightTheme;
        final ThemeData darkTheme = prefs.highContrastMode
            ? AppTheme.darkHighContrastTheme
            : AppTheme.darkTheme;

        return MaterialApp(
          title: 'Lorcana Score Keeper',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: const PlayScreen(),
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, __) => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Erreur de chargement des préférences'),
          ),
        ),
      ),
    );
  }
}
