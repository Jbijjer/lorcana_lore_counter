# Instructions pour finaliser les modifications

## Étape 1 : Générer les fichiers avec build_runner

Les modifications apportées aux modèles nécessitent la regénération des fichiers générés automatiquement :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cette commande va générer :
- `player_name.g.dart` - Adapter Hive pour le modèle PlayerName
- `player.freezed.dart` et `player.g.dart` - Code généré pour le modèle Player
- `game_provider.g.dart` - Code généré pour le provider Riverpod

## Étape 2 : Tester l'application

Lancez l'application et testez les nouvelles fonctionnalités :

### Test du dialog de sélection (clic simple)
1. Démarrez une partie
2. Cliquez sur le nom d'un joueur
3. Vérifiez que le dialog affiche la liste des joueurs sans le bouton pinceau
4. Sélectionnez un joueur ou créez-en un nouveau

### Test du dialog d'édition (long press)
1. Dans le dialog de sélection, faites un **appui long** sur un joueur existant
2. Le dialog d'édition devrait s'ouvrir avec :
   - Un aperçu du joueur avec son nom et son icône
   - Un champ pour modifier le nom
   - Une grille de 24 icônes disponibles
   - Un bouton pour modifier les couleurs de fond
3. Testez les modifications :
   - Changez le nom
   - Sélectionnez une nouvelle icône
   - Changez les couleurs de fond
   - Enregistrez les modifications
4. Vérifiez que les changements sont :
   - Appliqués immédiatement si c'est le joueur actuel
   - Sauvegardés dans l'historique pour la prochaine utilisation

### Test de la persistance
1. Éditez un joueur avec un nom, une icône et des couleurs personnalisées
2. Terminez la partie
3. Démarrez une nouvelle partie
4. Sélectionnez le même joueur
5. Vérifiez que son icône et ses couleurs sont bien restaurées

## Étape 3 : Vérifier les modifications

Si tout fonctionne correctement :
- ✅ Le bouton pinceau a disparu du dialog de sélection
- ✅ L'appui long ouvre le dialog d'édition
- ✅ Les icônes personnalisées s'affichent correctement
- ✅ Les préférences sont sauvegardées et restaurées

## Nouveaux fichiers créés

- `lib/core/constants/player_icons.dart` - Liste des 24 icônes disponibles
- `lib/features/game/presentation/widgets/player_edit_dialog.dart` - Dialog d'édition complet

## Fichiers modifiés

### Modèles
- `lib/features/game/domain/player_name.dart` - Ajout du champ `iconCodePoint`
- `lib/features/game/domain/player.dart` - Ajout du champ `iconCodePoint`

### Services
- `lib/features/game/data/player_history_service.dart` - Méthodes `getPlayerIcon()` et `updatePlayerIcon()`

### Providers
- `lib/features/game/presentation/providers/game_provider.dart` - Méthodes `changePlayer1Icon()` et `changePlayer2Icon()`

### UI
- `lib/features/game/presentation/widgets/player_name_dialog.dart` - Retrait du pinceau, ajout du long press
- `lib/features/game/presentation/widgets/player_zone.dart` - Affichage de l'icône personnalisée
- `lib/features/game/presentation/screens/play_screen.dart` - Chargement et sauvegarde des icônes

## En cas de problème

Si vous rencontrez des erreurs après `build_runner` :
1. Vérifiez que toutes les dépendances sont à jour : `flutter pub get`
2. Nettoyez le cache : `flutter clean`
3. Relancez build_runner : `flutter pub run build_runner build --delete-conflicting-outputs`

## Icônes disponibles

24 icônes sont disponibles pour personnaliser les joueurs :
- Personne, Étoile, Cœur, Trophée, Éclair
- Magie, Fusée, Bouclier, Couronne, Feu
- Diamant, Patte, Jeu, Palette, Musique
- Dé, Gâteau, Fleur, Insecte, Lune
- Soleil, Flocon, Cerveau, Pouce levé

Vous pouvez facilement ajouter d'autres icônes dans `lib/core/constants/player_icons.dart`.
