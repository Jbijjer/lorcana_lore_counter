// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accessibilityNotifierHash() =>
    r'00a67763d4a63287c4dcf404a3d3a6c0e851f141';

/// Provider pour gérer les préférences d'accessibilité
///
/// Copied from [AccessibilityNotifier].
@ProviderFor(AccessibilityNotifier)
final accessibilityNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AccessibilityNotifier, AccessibilityPreferences>.internal(
  AccessibilityNotifier.new,
  name: r'accessibilityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accessibilityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccessibilityNotifier
    = AutoDisposeAsyncNotifier<AccessibilityPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
