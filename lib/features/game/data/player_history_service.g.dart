// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_history_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playerHistoryServiceHash() =>
    r'f8c3e5b2d1a4c9e7f6d8b3a5c2e1f4d9';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef PlayerHistoryServiceRef = ProviderRef<PlayerHistoryService>;
String _$playerNamesHash() => r'a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7';

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
