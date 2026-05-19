// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiCreditsAvailableHash() =>
    r'7aaa6a46edabe713c2aff4d48ae3c541cbe8879b';

/// See also [aiCreditsAvailable].
@ProviderFor(aiCreditsAvailable)
final aiCreditsAvailableProvider = AutoDisposeProvider<bool>.internal(
  aiCreditsAvailable,
  name: r'aiCreditsAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiCreditsAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiCreditsAvailableRef = AutoDisposeProviderRef<bool>;
String _$recommendationNotifierHash() =>
    r'c570d1c6d726fde414f7e5f2a7292d4beac71b3b';

/// See also [RecommendationNotifier].
@ProviderFor(RecommendationNotifier)
final recommendationNotifierProvider =
    NotifierProvider<RecommendationNotifier, AsyncValue<WorkoutPlan?>>.internal(
      RecommendationNotifier.new,
      name: r'recommendationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recommendationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecommendationNotifier = Notifier<AsyncValue<WorkoutPlan?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
