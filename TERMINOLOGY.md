# 📖 Terminologie - Lorcana Lore Counter

Ce document définit la terminologie officielle utilisée dans l'application pour éviter toute confusion.

---

## Termes principaux

### 🎯 Partie
**Définition** : Un jeu individuel qui se termine lorsqu'un joueur atteint 20 lore (ou 25 si la victoire a été refusée), ou se termine en match nul.

**Exemples** :
- Alice atteint 20 lore, Bob a 15 lore → Fin de la partie, Alice gagne
- Alice atteint 20 lore, refuse la victoire (seuil passe à 25), puis Bob atteint 20 → Fin de la partie, Bob gagne
- Les deux joueurs finissent à égalité → Match nul

**Dans les statistiques** :
- Chaque partie compte comme **1 victoire** ou **1 défaite** (ou 1 nul)
- Le winrate se calcule sur le nombre de parties gagnées

---

### 🏆 Round (Best of 3 / Best of 5)
**Définition** : Une série de parties jouées pour déterminer un vainqueur global. Le premier joueur à gagner le nombre requis de parties remporte le round.

**Formats** :
- **Best of 1** : 1 partie → Le gagnant de la partie gagne le round
- **Best of 3** : 2 parties gagnées nécessaires → Maximum 3 parties jouées
- **Best of 5** : 3 parties gagnées nécessaires → Maximum 5 parties jouées

**Exemples Best of 3** :
- Round 1 : Alice gagne 20-15
- Round 2 : Alice gagne 20-18
- **Résultat** : Alice remporte le round 2-0 (2 parties gagnées)

**Dans l'application** :
- Le compteur de victoires (player1Wins / player2Wins) indique combien de parties chaque joueur a gagné dans le round en cours
- Le round se termine quand un joueur atteint le nombre de victoires nécessaires

---

### 🏅 Tournoi
**Définition** : Un enchainement de plusieurs rounds (Best of 3/5) entre différents joueurs.

**État** : ❌ **Non géré par l'application** (fonctionnalité future potentielle)

---

## Mapping avec le code

### Fichiers et variables
| Terme utilisateur | Nom dans le code | Fichier principal |
|-------------------|------------------|-------------------|
| Partie | `GameHistory` | `game_history.dart` |
| Round | `GameState` avec `matchFormat` | `game_state.dart` |
| Score de partie | `player1FinalScore` / `player2FinalScore` | `game_history.dart` |
| Victoires de parties dans le round | `player1Wins` / `player2Wins` | `game_state.dart` |

### Dans les statistiques
```dart
// PlayerStatistics compte les PARTIES :
- stats.wins    → Nombre de parties gagnées (pas de rounds)
- stats.losses  → Nombre de parties perdues
- stats.draws   → Nombre de parties nulles
- stats.winrate → (parties gagnées / total parties) × 100
```

---

## Exemples concrets

### Exemple 1 : Round Best of 3 complet
```
Round Best of 3 entre Alice et Bob :

Partie 1 : Alice 20 - Bob 15 → Alice gagne la partie
Partie 2 : Bob 20 - Alice 18 → Bob gagne la partie
Partie 3 : Alice 20 - Bob 11 → Alice gagne la partie

Résultat du round : Alice remporte le round 2-1

Dans les statistiques :
- Alice : +2 victoires (parties 1 et 3)
- Bob : +1 victoire (partie 2)
```

### Exemple 2 : Partie avec refus de victoire
```
Partie entre Alice et Bob :

Alice atteint 20 lore → Dialogue de victoire
Bob refuse → Seuil de Bob passe à 25
Le jeu continue...
Bob atteint 25 lore → Bob gagne la partie

Résultat : Bob gagne 25-20

Dans les statistiques :
- Bob : +1 victoire
- Alice : +1 défaite
```

---

## Notes pour les développeurs

⚠️ **Important** : Toujours se référer à ce document lors de l'ajout de nouvelles fonctionnalités liées aux scores, victoires, ou statistiques.

Si vous voyez des incohérences dans le code par rapport à cette terminologie, créez une issue pour discussion avant de modifier.

---

*Dernière mise à jour : 2025-11-20*
