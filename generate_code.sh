#!/bin/bash

echo "🔧 Vérification de l'environnement..."
echo ""

# Vérifier si flutter est disponible
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé ou pas dans le PATH"
    exit 1
fi

echo "✅ Flutter trouvé: $(flutter --version | head -1)"
echo ""

echo "🧹 Nettoyage..."
flutter clean

echo ""
echo "📦 Récupération des dépendances..."
flutter pub get

echo ""
echo "🏗️  Génération du code avec build_runner..."
echo ""

dart run build_runner build --delete-conflicting-outputs --verbose

echo ""
echo "📋 Vérification des fichiers générés..."
echo ""

if [ -f "lib/features/game/domain/game_history.freezed.dart" ]; then
    echo "✅ game_history.freezed.dart généré"
else
    echo "❌ game_history.freezed.dart MANQUANT"
fi

if [ -f "lib/features/game/domain/game_history.g.dart" ]; then
    echo "✅ game_history.g.dart généré"
else
    echo "❌ game_history.g.dart MANQUANT"
fi

if [ -f "lib/features/game/data/game_statistics_service.g.dart" ]; then
    echo "✅ game_statistics_service.g.dart généré"
else
    echo "❌ game_statistics_service.g.dart MANQUANT"
fi

echo ""
echo "✨ Terminé !"
