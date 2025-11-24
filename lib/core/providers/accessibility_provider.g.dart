// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accessibilityNotifierHash() =>
    r'83adaf2053b3eb27279f91d4f0f3579fd563f2cf';

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
