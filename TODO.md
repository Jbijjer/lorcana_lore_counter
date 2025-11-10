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

### 10. Bouton central dynamique et interactif
- [ ] Animation flip (pièce de monnaie) lors d'événements clés
- [ ] Transformation du bouton selon l'état de la partie :
  - [ ] État normal : logo Lorcana (menu radial)
  - [ ] État victoire : "Win!" (quand un joueur atteint 20 points)
  - [ ] État égalité : "Time!" (quand le compteur Time atteint 0)
- [ ] Bouton "Win!" pour confirmer la victoire
  - [ ] S'affiche avec animation flip quand un joueur atteint 20
  - [ ] Retour à l'état normal si le score descend sous 20
  - [ ] Clic confirme la victoire et affiche le dialog
- [ ] Bouton "Time!" pour confirmer l'égalité
  - [ ] S'affiche avec animation flip quand le compteur atteint 0
  - [ ] Clic confirme l'égalité et termine la partie
- [ ] Menu radial du bouton central (état normal)
  - [ ] Bouton central qui fait apparaître d'autres boutons autour (menu expandable)
  - [ ] Animation d'expansion/contraction du menu radial
- [ ] Bouton "Time" : compteur manuel de tours
  - [ ] Affichage d'un compteur à droite du bouton central
  - [ ] Compteur de 5 à 0 (décrémenté manuellement par les joueurs)
  - [ ] Boutons +/- pour modifier le compteur
  - [ ] Alerte visuelle quand le compteur atteint 0
  - [ ] Fin de partie automatique à 0 (partie nulle)
  - [ ] Possibilité de réinitialiser le compteur
- [ ] Bouton "Reset" : remise à zéro rapide
  - [ ] Remet les scores à 0 pour les deux joueurs
  - [ ] Dialog de confirmation optionnel
  - [ ] Animation de transition
- [ ] Autres boutons potentiels :
  - [ ] Bouton historique des rounds
  - [ ] Bouton paramètres rapides
  - [ ] Bouton changement de couleurs

### 11. Écran de configuration pré-partie
- [ ] Sélection des noms de joueurs
- [ ] Sélection des couleurs
- [ ] Choix du mode (Best of X)
- [ ] Bouton "Démarrer la partie"

### 12. Système de Tournoi et Rounds
**Informations à capturer par partie :**
- [ ] Quel round du tournoi sommes-nous (ex: Round 1/5)
- [ ] Le deck de l'adversaire (ses 2 couleurs parmi Amber, Amethyst, Emerald, Ruby, Sapphire, Steel)
- [ ] Position de départ : Play (commence en premier) ou Draw (joue en deuxième)
- [ ] Le pointage final des 2 joueurs
- [ ] Une note/commentaire lorsqu'on enregistre la partie (optionnel)

**Logique du bouton central - Menu radial étendu :**
- [ ] Ajouter option "Nouveau tournoi" dans le menu radial
  - [ ] Si un tournoi est déjà en cours, demander confirmation pour quitter
  - [ ] Dialog: "Voulez-vous quitter le tournoi actuel?"
  - [ ] Si oui, demander: "Voulez-vous garder ou ignorer les statistiques du tournoi abandonné?"
  - [ ] Au démarrage d'un tournoi, demander le nombre de rounds (ex: 3, 4, 5, 6 rounds)
  - [ ] Initialiser le compteur de round à 1/X

- [ ] Ajouter option "Nouveau round" dans le menu radial
  - [ ] Désactivé si aucun tournoi n'est en cours
  - [ ] Au clic, vider le nom de l'adversaire actuel
  - [ ] Demander d'entrer le nouveau nom d'adversaire
  - [ ] Incrémenter le compteur de round (ex: 2/5)
  - [ ] Réinitialiser les scores à 0
  - [ ] Garder les informations du tournoi en cours

**Système Best of 3 par round :**
- [ ] Chaque round de tournoi est un Best of 3 (match de 3 parties)
- [ ] Afficher des indicateurs visuels (2 ronds ou étoiles) pour suivre les victoires
  - [ ] 2 indicateurs gris par défaut
  - [ ] Deviennent blancs (ou colorés) quand on remporte une partie
  - [ ] Premier joueur à 2 victoires remporte le round
- [ ] À la fin d'un round (Best of 3), proposer automatiquement "Nouveau round"
- [ ] Sauvegarder les résultats de chaque partie du round

**Dialog de fin de partie (après victoire) :**
- [ ] Afficher le gagnant et les scores finaux
- [ ] Formulaire pour capturer les informations :
  - [ ] Deck de l'adversaire (2 couleurs)
  - [ ] Position de départ (Play/Draw)
  - [ ] Note/commentaire (champ texte optionnel)
- [ ] Bouton "Enregistrer" pour sauvegarder les données
- [ ] Bouton "Partie suivante" (dans un Best of 3)

## 🎨 Basse Priorité

### 13. Logo Lorcana SVG
- [ ] Remplacer Icons.auto_awesome par vrai logo
- [ ] Trouver/créer SVG du logo Lorcana
- [ ] Intégrer avec flutter_svg

### 14. Statistiques avancées
- [ ] Graphiques de progression
- [ ] Winrate global par joueur
- [ ] Temps moyen de partie
- [ ] Scores moyens
- [ ] Export en CSV/JSON

### 15. Animations et polish
- [ ] Animation sur changement de score (scale, bounce)
- [ ] Particules de victoire (confetti, étoiles)
- [ ] Transitions de page fluides
- [ ] Animations de gradient
- [ ] Effets visuels amusants (Lottie/Rive pour animations vectorielles)
- [ ] Animation de célébration à 20 points (feux d'artifice, particules)
- [ ] Feedback visuel sur les interactions (ripple effects, micro-animations)
- [ ] Animations de transition entre les scores (counter animation)
- [ ] Shake animation quand le score descend
- [ ] Glow effect autour du bouton central

### 16. Mode nuit/jour
- [ ] Toggle thème clair/sombre manuel
- [ ] Couleurs adaptées pour chaque mode
- [ ] Persistance de la préférence

### 17. Support multi-langues
- [ ] Français
- [ ] Anglais
- [ ] Utiliser package intl ou easy_localization

## ♿ Accessibilité

### 18. Mode à contraste élevé
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
