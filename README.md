# Lorcana Lore Counter

Application mobile Flutter pour compter les points de Lore dans le jeu de cartes Disney Lorcana.

## Description

Compteur de score moderne et épuré pour deux joueurs, avec :
- Interface colorée avec dégradés
- Boutons +/- (tap: ±1, long press: ±5)
- Barre de progression vers 20 points
- Détection automatique de victoire
- Feedback haptique
- Boutons Undo et Menu (UI)

## Technologies

- **Flutter** - Framework UI multiplateforme
- **Riverpod** - Gestion d'état
- **Freezed** - Classes immuables
- **Hive** - Base de données locale NoSQL

## Commandes de lancement

⚠️ À FAIRE AVANT D'UTILISER :

 IMPORTANT : Exécuter flutter pub run build_runner build --delete-conflicting-outputs
Cela génère les fichiers .freezed.dart et .g.dart nécessaires

### Linux

```bash
# Lancer sur Linux (bureau)
flutter run -d linux
```

### Windows

```bash
# Lancer sur Windows (bureau)
flutter run -d windows
```

### Android (ADB sans fil)

```bash
# 1. Connecter l'appareil Android en USB et activer le débogage USB
# 2. Vérifier que l'appareil est détecté
adb devices

# 3. Activer ADB en mode sans fil (port 5555)
adb tcpip 5555

# 4. Trouver l'adresse IP de l'appareil Android
# (Paramètres > À propos du téléphone > État > Adresse IP)
# Par exemple: 192.168.1.100

# 5. Connecter via ADB sans fil (remplacer par votre IP)
adb connect 192.168.1.100:5555

# 6. Débrancher le câble USB et vérifier la connexion
adb devices

# 7. Lancer l'application
flutter run

# Pour déconnecter
adb disconnect 192.168.1.100:5555
```

### Commandes utiles

```bash
# Lister tous les appareils connectés
flutter devices

# Installer les dépendances
flutter pub get

# Générer le code (Freezed, Riverpod)
dart run build_runner build

# Nettoyer le build
flutter clean

# Construire l'APK Android
flutter build apk

# Construire l'app Windows
flutter build windows

# Construire l'app Linux
flutter build linux
```

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée
├── core/                     # Configuration, thème, constants
├── features/
│   └── game/
│       ├── data/            # Modèles et sources de données
│       ├── domain/          # Logique métier
│       └── presentation/    # UI et providers
```

## Développement

- Architecture clean (data/domain/presentation)
- Provider pattern avec Riverpod
- Sérialisation JSON avec Freezed
- Persistance avec Hive

## TODO

Voir [TODO.md](TODO.md) pour la liste complète des fonctionnalités à venir.
