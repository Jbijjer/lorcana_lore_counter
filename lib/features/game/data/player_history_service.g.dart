// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_history_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerHistoryServiceHash() =>
    r'19da17f85c9e12a6c065b16d1026839f1644acac';

/// Provider pour le service d'historique des joueurs
///
/// Copied from [playerHistoryService].
@ProviderFor(playerHistoryService)
final playerHistoryServiceProvider = Provider<PlayerHistoryService>.internal(
  playerHistoryService,
  name: r'playerHistoryServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerHistoryServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerHistoryServiceRef = ProviderRef<PlayerHistoryService>;
String _$playerNamesHash() => r'cedc1efc51012f2237038d98977b6343f807e41a';

/// Provider pour la liste des noms de joueurs
///
/// Copied from [playerNames].
@ProviderFor(playerNames)
final playerNamesProvider = AutoDisposeProvider<List<String>>.internal(
  playerNames,
  name: r'playerNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playerNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerNamesRef = AutoDisposeProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
