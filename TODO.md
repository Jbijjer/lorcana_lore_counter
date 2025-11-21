# TODO - Lorcana Lore Counter

Inspiré de **Lore Tracker (Perfect Pixels)** et des meilleures pratiques UX pour compteurs de score.

## 🎉 Travaux récents (derniers commits)

**Refactorisation et améliorations des dialogues:**
- ♻️ Refactorisation complète des dialogues avec widgets atomiques réutilisables (Commit 859fd8f)
- 🐛 Corrections multiples des dialogues (scroll, taille boutons, SparklesOverlay)
- ✨ Bouton 'Nouveau joueur' toujours visible dans les dialogues

**Animations et effets visuels:**
- 🎨 Confettis Mickey avec animations améliorées (disparition progressive, échelonnement)
- ✨ Animation de flip avec grandissement préalable
- ✨ Effets shimmer sur tous les boutons de sélection de joueurs
- ⚡ Optimisation de la vitesse des confettis

**Menu radial et victoire:**
- ✨ Utilisation des jetons vert et rouge pour le menu radial de victoire (Commit 61532d5)
- ✨ Point d'interrogation après "Victoire"
- ✨ Jeton multicolor pour l'affichage de victoire
- ✨ Clic sur logo = Non quand menu radial ouvert

**Corrections techniques:**
- 🔄 Migration vers Hive CE puis revert vers Hive standard
- 🔧 Génération du code avec build_runner
- ✨ Correction complète des warnings Flutter

## ✅ Complété

- [x] Interface épurée avec dégradés colorés
- [x] Typographie grasse pour les scores (FontWeight.w900)
- [x] Coins arrondis (forme téléphone moderne)
- [x] Boutons +/- 
- [x] Détection automatique de victoire
- [x] Feedback haptique
- [x] Bouton Menu/Options (UI seulement)
- [x] Couleurs personnalisables avec palette Lorcana
- [x] Modification manuelle du score (long press)
- [x] Logo Lorcana intégré

## 🔥 Haute Priorité

### 0. Système de statistiques ✅ COMPLÉTÉ

**✅ Complété :**
- [x] Modèle de données `GameHistory` avec Hive (typeId: 2, 3)
- [x] Service `GameStatisticsService` pour stocker/récupérer les parties
- [x] Sauvegarde automatique des parties terminées dans `GameProvider`
- [x] Écran `StatisticsScreen` avec vue d'ensemble et historique
- [x] Widgets `StatisticsOverviewCard` et `GameHistoryCard`
- [x] Initialisation du service dans `main.dart`
- [x] Exécution de `flutter pub run build_runner build --delete-conflicting-outputs`
- [x] Créer le widget de menu radial pour le bouton central
  - [x] Animation d'expansion/contraction
  - [x] Bouton "Statistiques" dans le menu
  - [x] Bouton "Reset" dans le menu
- [x] Modifier `_CenterDivider` dans `play_screen.dart` pour utiliser le menu radial
- [x] Ajouter la navigation vers `StatisticsScreen` depuis le menu radial
- [x] Tester la sauvegarde et l'affichage des statistiques
- [x] Application du thème Material 3 aux statistiques
- [x] Tri alphabétique des joueurs dans la vue d'ensemble
- [x] Correction du fond (utilisation de `colorScheme.surfaceBright`)

**📊 Fonctionnalités opérationnelles :**
- ✅ Compteur de parties jouées
- ✅ Victoires par joueur avec pourcentage de winrate
- ✅ Suppression individuelle ou globale des statistiques
- ✅ Historique complet des parties avec détails
- ✅ Support des parties nulles
- ✅ Affichage des couleurs de deck

**⏸️ Améliorations optionnelles (reportées) :**
- [ ] Animations de transition vers l'écran stats
- [ ] Feedback haptique supplémentaire sur les actions

### 1. Auto-save avec Hive ✅ COMPLÉTÉ
- [x] Créer adaptateur Hive pour GameState
- [x] Sauvegarder automatiquement après chaque changement de score
- [x] Charger la dernière partie au démarrage
- [x] Persister l'état même après fermeture de l'app

**✅ Fonctionnalités opérationnelles :**
- ✅ Sauvegarde automatique à chaque modification d'état (GameProvider._saveState())
- ✅ Stockage via Hive en format JSON (GamePersistenceService)
- ✅ Chargement automatique au démarrage si partie en cours
- ✅ Détection intelligente : sauvegarde uniquement si status == inProgress
- ✅ Suppression automatique quand la partie se termine
- ✅ Gestion d'erreur : supprime les sauvegardes corrompues

### 2. Page d'accueil de l'application ✅ COMPLÉTÉ
- [x] Créer une page d'accueil pour l'application
- [x] Bouton "Continuer Partie"
  - [x] Afficher un résumé de la partie en cours (joueurs, scores)
  - [x] L'usager doit confirmer s'il veut reprendre cette partie
- [x] Bouton "Nouveau Round"
  - [x] Si une partie est en cours, avertir que celle-ci sera effacée
  - [x] Dialog de confirmation avant d'effacer la partie en cours
- [x] Bouton "Statistiques"
  - [x] Navigation vers l'écran de statistiques existant
- [x] Bouton "Paramètres"
  - [x] Navigation vers l'écran de paramètres
- [x] Afficher la version de l'appli en bas à gauche en petit
- [x] Utiliser le look et le style des autres fenêtres pour la créer
  - [x] Reprendre les dégradés colorés
  - [x] Coins arrondis cohérents avec le reste de l'app
  - [x] Typographie et espacement similaires

**✅ Fonctionnalités opérationnelles :**
- ✅ HomeScreen avec logo Lorcana animé (flip périodique)
- ✅ Détection automatique de partie en cours
- ✅ Bouton "Continuer Partie" avec dialogue de confirmation et résumé complet
- ✅ Bouton "Nouveau Round" avec avertissement si partie en cours
- ✅ Navigation vers Statistiques et Paramètres
- ✅ Version affichée en bas de l'écran
- ✅ Design cohérent avec dégradés et Material 3

### 3. Restart rapide (One-tap) ✅
- [x] Ajouter dialog de confirmation avec animation
- [x] Implémenter reset des scores seulement (garder joueurs)
- [x] Animation de transition (flash blanc avec icône)
- [x] Option "Réinitialiser Partie" vs "Réinitialiser Round"

## 🎨 Problèmes Design / Contraste

- [x] Encore plus de contraste dans les thèmes
- [x] Des contours noirs
- [x] Des couleurs flagrantes
- [x] Les dégradés ne fonctionnent pas

## 📊 Moyenne Priorité

### 6. Match Tracking (Best of X)
- [x] Ajouter sélection mode: Best of 1/2/3/5 ✅ (Commit 9d92e7b)
- [x] Compteur de victoires par joueur
- [x] Afficher "Match X of Y"
- [x] Détecter fin de match complet
- [x] Résumé final du match

### 7. Historique des parties ✅ COMPLÉTÉ (voir section 0)
- [x] Sauvegarder les parties complètes (toutes les parties, pas de limite)
- [x] Écran liste des parties passées (`StatisticsScreen` avec onglet Historique)
- [x] Détails d'une partie (scores finaux, gagnant, date, couleurs de deck)
- [x] Option de supprimer une partie de l'historique
- [x] Statistiques de base (winrate par joueur, parties jouées, parties nulles)

### 8. Section d'aide
- [ ] Créer une section d'aide accessible depuis le menu principal ou les paramètres
- [ ] Expliquer toutes les petites fonctionnalités de l'application :
  - [ ] Fonctionnement du menu radial central
  - [ ] Long press pour modifier manuellement un score
  - [ ] Système de confirmation de victoire
  - [ ] Modes de jeu (Best of 1/2/3/5)
  - [ ] Statistiques et historique des parties
  - [ ] Feedback haptique
  - [ ] Animations et effets visuels
  - [ ] Personnalisation des couleurs de deck
  - [ ] Gestion des parties nulles
- [ ] Utiliser un format accessible et facile à parcourir (accordéons, sections pliables, etc.)
- [ ] Ajouter des captures d'écran ou des illustrations si pertinent

### 11. Écran de configuration pré-partie
- [x] Sélection des noms de joueurs ✅ (Commit e0b6458 - transformation magique)
- [x] Sélection des couleurs ✅
- [x] Choix du mode (Best of X) ✅ (Commit 9d92e7b)
- [x] Bouton "Démarrer la partie" ✅

## 🎨 Basse Priorité

### 13. Statistiques avancées
- [ ] Graphiques de progression
- [x] Winrate global par joueur ✅ (déjà implémenté)
- [ ] Scores moyens

### 14. Animations et polish
- [x] Animation sur changement de score (scale, bounce)
- [x] Particules de victoire (confetti, étoiles) ✅ (Commits 61e3bd7, 440411c, 42af3e9, 584b7b3, 8197c08, 50f3ddc, a42a34c, 23b1625 - confettis Mickey)
- [x] Transitions de page fluides
- [x] Animations de gradient
- [ ] Effets visuels amusants (Lottie/Rive pour animations vectorielles)
- [x] Animation de célébration à 20 points (feux d'artifice, particules) ✅ (confettis Mickey)
- [x] Feedback visuel sur les interactions (ripple effects, micro-animations) ✅ (Commits 4b07c92, 0849033 - shimmer effects)
- [x] Animations de transition entre les scores (counter animation)
- [x] Shake animation quand le score descend
- [x] Glow effect autour du bouton central

## 📝 Notes techniques

- Hive déjà initialisé dans main.dart
- Riverpod + Freezed en place
- Structure clean architecture respectée
- Générer code: `dart run build_runner build`
