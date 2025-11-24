// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_checker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateCheckerServiceHash() =>
    r'a8f691fc14f50a9a2c3060796aeebb127f4f1558';

/// Provider pour le service de vérification des mises à jour
///
/// Copied from [updateCheckerService].
@ProviderFor(updateCheckerService)
final updateCheckerServiceProvider =
    AutoDisposeProvider<UpdateCheckerService>.internal(
  updateCheckerService,
  name: r'updateCheckerServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateCheckerServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateCheckerServiceRef = AutoDisposeProviderRef<UpdateCheckerService>;
String _$updateCheckerHash() => r'3c347956becb5b09d552832d0acf5e561dd35f63';

/// Provider pour gérer l'état de la vérification des mises à jour
///
/// Copied from [UpdateChecker].
@ProviderFor(UpdateChecker)
final updateCheckerProvider =
    AutoDisposeNotifierProvider<UpdateChecker, UpdateCheckState>.internal(
  UpdateChecker.new,
  name: r'updateCheckerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateCheckerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateChecker = AutoDisposeNotifier<UpdateCheckState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
