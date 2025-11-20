# 📊 Feuille de route - Système de statistiques

## Phase 1 : Génération du code (CRITIQUE) ⚠️
**Durée estimée : 5 minutes**

### Tâche 1.1 : Générer les fichiers Freezed/Hive
- **Action** : Exécuter `flutter pub run build_runner build --delete-conflicting-outputs`
- **Raison** : Génère les fichiers `.freezed.dart` et `.g.dart` nécessaires pour les modèles
- **Bloquant** : OUI - Sans cela, le code ne compile pas
- **Fichiers concernés** :
  - `lib/models/game_history.freezed.dart`
  - `lib/models/game_history.g.dart`
  - Autres modèles utilisant Freezed

---

## Phase 2 : Intégration au menu radial (ESSENTIEL)
**Durée estimée : 2-3 heures**

### Tâche 2.1 : Ajouter le bouton "Statistiques" au menu radial
- **Fichier** : `lib/widgets/center_radial_menu.dart` (ou similaire)
- **Actions** :
  - Ajouter un nouveau `RadialMenuItem` pour "Statistiques"
  - Définir l'icône (📊 ou Icons.analytics)
  - Définir l'action de navigation
- **Dépendances** : Phase 1 complétée
- **Complexité** : Faible

### Tâche 2.2 : Implémenter la navigation vers StatisticsScreen
- **Fichier** : `lib/screens/play_screen.dart`
- **Actions** :
  - Ajouter la route vers `StatisticsScreen`
  - Gérer la navigation depuis le menu radial
  - S'assurer que le menu se ferme après navigation
- **Dépendances** : Tâche 2.1
- **Complexité** : Faible

---

## Phase 3 : Fonctionnalités optionnelles du menu
**Durée estimée : 2-4 heures**

### Tâche 3.1 : Ajouter bouton "Historique des rounds"
- **Prérequis** : Déterminer si cette fonctionnalité est différente de "Statistiques"
- **Actions** :
  - Si différent : créer un écran séparé pour l'historique détaillé
  - Si identique : naviguer vers l'onglet historique de StatisticsScreen
- **Complexité** : Moyenne (selon la décision)

### Tâche 3.2 : Ajouter bouton "Timer" (OPTIONNEL)
- **Note** : Marqué comme "si implémenté" dans le TODO
- **Actions** :
  - Évaluer si cette fonctionnalité est nécessaire maintenant
  - Si oui : implémenter le compteur de tours (voir TODO section 10)
  - Si non : reporter à plus tard
- **Complexité** : Moyenne-Élevée
- **Recommandation** : Reporter après la finalisation des stats de base

---

## Phase 4 : Tests et validation
**Durée estimée : 1-2 heures**

### Tâche 4.1 : Tester la sauvegarde des parties
- **Scénarios de test** :
  - Jouer une partie complète et vérifier qu'elle est sauvegardée
  - Fermer et rouvrir l'app, vérifier que les stats persistent
  - Jouer plusieurs parties (Best of 3, Best of 5)
  - Tester avec différents joueurs
- **Fichiers à vérifier** : `lib/providers/game_provider.dart`

### Tâche 4.2 : Tester l'affichage des statistiques
- **Scénarios de test** :
  - Vérifier que les compteurs s'affichent correctement
  - Tester le calcul du winrate
  - Vérifier l'affichage de l'historique
  - Tester la suppression de parties individuelles
  - Tester la suppression globale
- **Fichiers à vérifier** :
  - `lib/screens/statistics_screen.dart`
  - `lib/widgets/statistics_overview_card.dart`
  - `lib/widgets/game_history_card.dart`

### Tâche 4.3 : Tests edge cases
- **Scénarios** :
  - Aucune partie jouée (écran vide)
  - Une seule partie jouée
  - Beaucoup de parties (performance)
  - Joueurs avec caractères spéciaux dans les noms

---

## Phase 5 : Polish et améliorations (OPTIONNEL)
**Durée estimée : 1-2 heures**

### Tâche 5.1 : Améliorations UX
- Ajouter animations de transition vers l'écran stats
- Ajouter feedback haptique sur les actions
- Améliorer les messages quand il n'y a pas de données

### Tâche 5.2 : Améliorations visuelles
- Vérifier la cohérence avec le design général
- S'assurer que les couleurs respectent les thèmes
- Ajouter des icônes/émojis pour rendre plus visuel

---

## 📋 Plan d'exécution recommandé

**Sprint 1 (CRITIQUE - À faire en premier)**
1. ✅ Phase 1 : Génération du code
2. ✅ Phase 2 : Intégration au menu radial

**Sprint 2 (Important)**
3. ✅ Phase 4 : Tests et validation
4. ⚠️ Phase 3.1 : Historique des rounds (clarifier besoin)

**Sprint 3 (Optionnel - selon temps disponible)**
5. ⏸️ Phase 3.2 : Timer (reporter si besoin)
6. ✨ Phase 5 : Polish

---

## 🎯 Critères de succès

Le système de statistiques sera considéré **100% fonctionnel** quand :
- ✅ Le code compile sans erreurs
- ✅ Le bouton "Statistiques" est accessible depuis le menu radial
- ✅ Les parties terminées sont automatiquement sauvegardées
- ✅ L'écran statistiques affiche correctement les données
- ✅ Le winrate est calculé correctement
- ✅ Les suppressions (individuelle/globale) fonctionnent
- ✅ Les données persistent après redémarrage de l'app

---

**Temps total estimé : 6-11 heures** (selon si on fait les optionnels)
**Temps minimum viable : 3-5 heures** (Phases 1, 2 et 4)

---

## 📝 Notes de progression

### Suivi des phases
- [ ] Phase 1 : Génération du code
- [ ] Phase 2 : Intégration au menu radial
- [ ] Phase 3 : Fonctionnalités optionnelles
- [ ] Phase 4 : Tests et validation
- [ ] Phase 5 : Polish

### Décisions à prendre
- [ ] Clarifier si "Historique des rounds" = "Statistiques" ou écran séparé
- [ ] Décider si le Timer doit être implémenté maintenant ou plus tard

### Bugs/Problèmes rencontrés
_(À documenter pendant le développement)_
