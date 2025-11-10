import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/screens/play_screen.dart';
import 'features/game/data/player_history_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive
  await Hive.initFlutter();

  // Créer le container de providers
  final container = ProviderContainer();

  // Initialiser le service d'historique des joueurs
  await container.read(playerHistoryServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LorcanaScoreKeeperApp(),
    ),
  );
}

/// Application principale
class LorcanaScoreKeeperApp extends StatelessWidget {
  const LorcanaScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lorcana Score Keeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PlayScreen(),
    );
  }
}
