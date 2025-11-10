# TODO - Lorcana Lore Counter

Inspiré de **Lore Tracker (Perfect Pixels)** et des meilleures pratiques UX pour compteurs de score.

## ✅ Complété

- [x] Interface épurée avec dégradés colorés
- [x] Typographie grasse pour les scores (FontWeight.w900)
- [x] Coins arrondis (forme téléphone moderne)
- [x] Boutons +/- simplifiés (tap: ±1, long press: ±5)
- [x] Barre de progression vers 20 points
- [x] Détection automatique de victoire
- [x] Feedback haptique
- [x] Bouton Undo (UI seulement)
- [x] Bouton Menu/Options (UI seulement)

## 🔥 Haute Priorité

### 1. Auto-save avec Hive
- [ ] Créer adaptateur Hive pour GameState
- [ ] Sauvegarder automatiquement après chaque changement de score
- [ ] Charger la dernière partie au démarrage
- [ ] Persister l'état même après fermeture de l'app

### 2. Fonctionnalité Undo
- [ ] Ajouter historique des actions dans GameState
- [ ] Implémenter méthode undo dans GameProvider
- [ ] Connecter le bouton Undo à la logique
- [ ] Limiter à 10-15 actions annulables
- [ ] Feedback visuel quand undo n'est pas disponible

### 3. Restart rapide (One-tap)
- [ ] Ajouter dialog de confirmation
- [ ] Implémenter reset des scores seulement (garder joueurs)
- [ ] Animation de transition
- [ ] Option "Nouvelle partie" vs "Reset scores"

### 4. Couleurs personnalisables
- [ ] Créer sélecteur de couleur pour chaque joueur
- [ ] Ajouter palette de couleurs Lorcana (Amber, Amethyst, Emerald, Ruby, Sapphire, Steel)
- [ ] Sauvegarder préférences de couleurs
- [ ] Appliquer couleurs aux zones de joueurs et boutons

### 5. Modification manuelle du score
- [ ] Implémenter dialog sur long press du score
- [ ] Champ de texte numérique
- [ ] Validation (0-99)
- [ ] Animation de transition

## 🎨 Problèmes Design / Contraste

- [ ] Encore plus de contraste dans les thèmes
- [ ] Des contours noirs
- [ ] Des couleurs flagrantes
- [ ] Les dégradés ne fonctionnent pas

## 📊 Moyenne Priorité

### 6. Match Tracking (Best of X)
- [ ] Ajouter sélection mode: Best of 1/2/3/5
- [ ] Compteur de victoires par joueur
- [ ] Afficher "Match X of Y"
- [ ] Détecter fin de match complet
- [ ] Résumé final du match

### 7. Historique des parties
- [ ] Sauvegarder les 15 dernières parties complètes
- [ ] Écran liste des parties passées
- [ ] Détails d'une partie (scores finaux, durée, gagnant)
- [ ] Option de supprimer une partie de l'historique
- [ ] Statistiques de base (winrate par joueur)

### 8. Menu d'options complet
- [ ] Écran de paramètres
- [ ] Choix du nombre de points pour gagner (20 par défaut, 10/15/25 optionnel)
- [ ] Toggle feedback haptique
- [ ] Toggle sons (si ajoutés)
- [ ] About/Credits
- [ ] Bouton "Effacer toutes les données"

### 9. Historique des rounds (bouton central)
- [ ] Dialog affichant les deltas par round
- [ ] Timeline visuelle des changements de score
- [ ] Informations: Round X, +Y points, timestamp
- [ ] Bouton fermer

### 10. Écran de configuration pré-partie
- [ ] Sélection des noms de joueurs
- [ ] Sélection des couleurs
- [ ] Choix du mode (Best of X)
- [ ] Bouton "Démarrer la partie"

## 🎨 Basse Priorité

### 11. Logo Lorcana SVG
- [ ] Remplacer Icons.auto_awesome par vrai logo
- [ ] Trouver/créer SVG du logo Lorcana
- [ ] Intégrer avec flutter_svg

### 12. Statistiques avancées
- [ ] Graphiques de progression
- [ ] Winrate global par joueur
- [ ] Temps moyen de partie
- [ ] Scores moyens
- [ ] Export en CSV/JSON

### 13. Animations et polish
- [ ] Animation sur changement de score
- [ ] Particules de victoire
- [ ] Transitions de page fluides
- [ ] Animations de gradient

### 14. Mode nuit/jour
- [ ] Toggle thème clair/sombre manuel
- [ ] Couleurs adaptées pour chaque mode
- [ ] Persistance de la préférence

### 15. Support multi-langues
- [ ] Français
- [ ] Anglais
- [ ] Utiliser package intl ou easy_localization

## ♿ Accessibilité

### 16. Mode à contraste élevé
- [ ] Implémenter un mode à contraste élevé pour l'application
- [ ] Assurer une lisibilité optimale pour les utilisateurs malvoyants
- [ ] Respecter les normes WCAG pour les ratios de contraste
- [ ] Ajouter un toggle dans les paramètres
- [ ] Persister la préférence utilisateur

## 🚀 Nice to Have

- [ ] Mode tournoi (bracket)
- [ ] Minuteur de partie
- [ ] Sons de victoire/défaite
- [ ] Partage de résultats (screenshot)
- [ ] Synchronisation cloud (Firebase)
- [ ] Support tablette (layout adaptatif)
- [ ] Widget iOS/Android (quick access)

## 📝 Notes techniques

- Hive déjà initialisé dans main.dart
- Riverpod + Freezed en place
- Structure clean architecture respectée
- Générer code: `dart run build_runner build`
