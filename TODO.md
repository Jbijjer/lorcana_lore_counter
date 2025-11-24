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
- [x] Bouton "Timer" dans le menu (voir section 10) ✅
- [x] Bouton "Historique des rounds" dans le menu ✅
- [x] Animations de transition vers l'écran stats ✅
- [x] Feedback haptique supplémentaire sur les actions ✅

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

### 8. Mode de saisie manuelle ✅ COMPLÉTÉ
- [x] Ajouter un bouton dans le menu principal pour accéder à un mode "manuel"
- [x] Créer une interface de saisie manuelle permettant d'entrer :
  - [x] Les joueurs participants
  - [x] Les couleurs de deck de chaque joueur
  - [x] Le score de chaque partie
  - [x] Qui a commencé chaque partie
- [x] Sauvegarder ces données dans l'historique des parties
- [x] Permettre l'ajout de plusieurs parties/rounds en une session
- [x] Interface intuitive qui ne nécessite pas de passer par l'interface de jeu complète

**✅ Fonctionnalités opérationnelles :**
- ✅ Bouton "Saisie Manuelle" sur l'écran d'accueil (couleur améthyste)
- ✅ Sélection des deux joueurs via le système existant
- ✅ Sélection des couleurs de deck (2 couleurs max par joueur)
- ✅ Saisie des scores avec validation (un joueur doit avoir >= 20 pts)
- ✅ Option Match nul disponible
- ✅ Sélection du premier joueur à commencer
- ✅ Note optionnelle sur la partie
- ✅ Sauvegarde dans l'historique des statistiques
- ✅ Possibilité d'enchaîner plusieurs parties

### 9. Bouton central dynamique et interactif
- [x] Animation flip (pièce de monnaie) lors d'événements clés ✅ (Commit 293edbf, cd0d27c)
- [x] Transformation du bouton selon l'état de la partie : ✅
  - [x] État normal : logo Lorcana (menu radial) ✅
  - [x] État victoire : "Win!" (quand un joueur atteint 20 points) ✅
- [x] Bouton "Win!" pour confirmer la victoire ✅
  - [x] S'affiche avec animation flip quand un joueur atteint 20 ✅ (Commit 293edbf)
  - [x] Retour à l'état normal si le score descend sous 20 ✅
  - [x] Clic confirme la victoire et affiche le dialog ✅ (Commit 3b7fbe9)
- [x] Menu radial du bouton central (état normal) ✅
  - [x] Bouton central qui fait apparaître d'autres boutons autour (menu expandable) ✅
  - [x] Animation d'expansion/contraction du menu radial ✅ (Commit 61532d5 - jetons vert/rouge)
- [x] Bouton "Dice" : lancer de dés ✅ (Commit 25b886f)
  - [x] Bouton dans le menu radial pour lancer 2 dés à 6 faces
  - [x] Animation de lancer de dés (rotation 3D réaliste - 800ms)
  - [x] Affichage des résultats des 2 dés avec faces de points
  - [x] Possibilité de relancer les dés
  - [x] Feedback haptique lors du lancer (medium + light)
  - [x] Overlay modal avec boutons "Relancer" et "Fermer"
  - [x] Style Lorcana (dégradés, couleurs du thème, animations pop)
  - [x] Affichage du total des 2 dés
- [x] Bouton "Time" : compteur manuel de tours ✅
  - [x] Affichage d'un compteur à droite du bouton central
  - [x] Compteur de 5 à 0 (décrémenté manuellement par les joueurs)
  - [x] Boutons +/- pour modifier le compteur
  - [x] Alerte visuelle quand le compteur atteint 0
  - [x] Fin de partie automatique à 0 (partie nulle)
  - [x] Possibilité de réinitialiser le compteur
- [x] Bouton "Reset" : remise à zéro rapide
  - [x] Remet les scores à 0 pour les deux joueurs
  - [x] Dialog de confirmation
  - [x] Animation de transition
- [x] Autres boutons potentiels : ✅
  - [x] Bouton historique des rounds
  - [x] Bouton paramètres rapides

### 10. Écran de configuration pré-partie
- [x] Sélection des noms de joueurs ✅ (Commit e0b6458 - transformation magique)
- [x] Sélection des couleurs ✅
- [x] Choix du mode (Best of X) ✅ (Commit 9d92e7b)
- [x] Bouton "Démarrer la partie" ✅

## 🎨 Basse Priorité

### 11. Animations et polish
- [x] Animation sur changement de score (scale, bounce)
- [x] Particules de victoire (confetti, étoiles) ✅ (Commits 61e3bd7, 440411c, 42af3e9, 584b7b3, 8197c08, 50f3ddc, a42a34c, 23b1625 - confettis Mickey)
- [x] Transitions de page fluides
- [x] Animations de gradient
- [x] Animation de célébration à 20 points (feux d'artifice, particules) ✅ (confettis Mickey)
- [x] Feedback visuel sur les interactions (ripple effects, micro-animations) ✅ (Commits 4b07c92, 0849033 - shimmer effects)
- [x] Animations de transition entre les scores (counter animation)
- [x] Shake animation quand le score descend
- [x] Glow effect autour du bouton central

## 🚀 Futures améliorations

### 12. Export des statistiques
- [ ] Export des stats en CSV
  - [ ] Exporter l'historique des parties (joueurs, scores, dates, couleurs de deck)
  - [ ] Exporter les statistiques par joueur (winrate, parties jouées)
  - [ ] Bouton d'export dans l'écran Statistiques
  - [ ] Partage du fichier CSV via le système de partage natif

### 13. Portraits personnalisés ✅ COMPLÉTÉ
- [x] Permettre d'ajouter des portraits à partir de photos sur l'appareil
  - [x] Accès à la galerie photos de l'appareil (image_picker)
  - [x] Recadrage/redimensionnement de l'image (image_cropper avec crop circulaire)
  - [x] Stockage local des portraits (répertoire documents/portraits)
  - [x] Affichage du portrait dans la sélection de joueur et sur l'écran de jeu

**✅ Fonctionnalités opérationnelles :**
- ✅ Bouton "Importer ma photo" dans le dialogue d'édition de joueur
- ✅ Sélection d'image depuis la galerie avec image_picker
- ✅ Recadrage circulaire avec image_cropper
- ✅ Stockage persistant des portraits dans le répertoire de l'application
- ✅ Affichage prioritaire du portrait personnalisé sur l'icône par défaut
- ✅ Option de supprimer le portrait personnalisé
- ✅ Fallback vers l'icône par défaut si le fichier portrait n'existe plus

### 14. Sauvegarde Cloud
- [ ] Synchronisation des données sur le Cloud
  - [ ] Intégration Google Drive / iCloud
  - [ ] Backup automatique des statistiques et historique
  - [ ] Restauration des données sur un nouvel appareil
  - [ ] Option d'activer/désactiver la sync dans les paramètres

## 📝 Notes techniques

- Hive déjà initialisé dans main.dart
- Riverpod + Freezed en place
- Structure clean architecture respectée
- Générer code: `dart run build_runner build`
