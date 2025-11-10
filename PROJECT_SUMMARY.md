# Lorcana Score Keeper - Résumé Projet

## Architecture
- Flutter app, Material 3
- Riverpod (état) + Freezed (modèles)
- Structure: lib/core/ (theme, utils) + lib/features/game/ (domain, presentation)

## Fonctionnalités actuelles (v0.1.0)
- Écran Play face-à-face (2 joueurs)
- Scores avec boutons +/-, +1/+2/+3
- Rotation 180° joueur 1
- Barre progression vers 20 points
- Détection victoire automatique
- Feedback haptique
- Couleurs Lorcana (Amber, Sapphire, etc.)

## Fichiers principaux
- `lib/features/game/domain/`: player.dart, game_state.dart
- `lib/features/game/presentation/providers/`: game_provider.dart
- `lib/features/game/presentation/screens/`: play_screen.dart
- `lib/features/game/presentation/widgets/`: player_zone.dart

## TODO - Priorités

### Haute (MVP)
1. **Historique rounds** - Afficher deltas de points par round (bouton central)
2. **Modification manuelle score** - Dialog sur long press du score
3. **Logo Lorcana** - Remplacer Icons.auto_awesome par SVG

### Moyenne (v0.2)
4. **Persistance Hive** - Sauvegarder parties automatiquement
5. **Écran config** - Sélection joueurs avant partie (noms, couleurs)
6. **Historique parties** - Liste + détails parties passées
7. **Bouton Undo** - Annuler dernière action

### Basse
8. Statistiques (winrate, graphiques)
9. Mode tournoi
10. Export données

## Modèles existants
- `Player`: id, name, color, gamesPlayed, gamesWon
- `GameState`: id, player1/2, scores, currentRound, rounds[], startTime, status
- `RoundScore`: roundNumber, deltas, totalScores, timestamp

## Notes techniques
- Utilisé `CardThemeData` (pas CardTheme)
- Assets désactivés dans pubspec.yaml
- Génération: `dart run build_runner build`
