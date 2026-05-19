// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseAnalyticsHash() => r'7609fb9a3ffc15acf15e27b179d64d27304ae773';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [exerciseAnalytics].
@ProviderFor(exerciseAnalytics)
const exerciseAnalyticsProvider = ExerciseAnalyticsFamily();

/// See also [exerciseAnalytics].
class ExerciseAnalyticsFamily extends Family<ExerciseAnalytics> {
  /// See also [exerciseAnalytics].
  const ExerciseAnalyticsFamily();

  /// See also [exerciseAnalytics].
  ExerciseAnalyticsProvider call(String exerciseId) {
    return ExerciseAnalyticsProvider(exerciseId);
  }

  @override
  ExerciseAnalyticsProvider getProviderOverride(
    covariant ExerciseAnalyticsProvider provider,
  ) {
    return call(provider.exerciseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseAnalyticsProvider';
}

/// See also [exerciseAnalytics].
class ExerciseAnalyticsProvider extends AutoDisposeProvider<ExerciseAnalytics> {
  /// See also [exerciseAnalytics].
  ExerciseAnalyticsProvider(String exerciseId)
    : this._internal(
        (ref) => exerciseAnalytics(ref as ExerciseAnalyticsRef, exerciseId),
        from: exerciseAnalyticsProvider,
        name: r'exerciseAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exerciseAnalyticsHash,
        dependencies: ExerciseAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            ExerciseAnalyticsFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  ExerciseAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseId,
  }) : super.internal();

  final String exerciseId;

  @override
  Override overrideWith(
    ExerciseAnalytics Function(ExerciseAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseAnalyticsProvider._internal(
        (ref) => create(ref as ExerciseAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseId: exerciseId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ExerciseAnalytics> createElement() {
    return _ExerciseAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseAnalyticsProvider && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExerciseAnalyticsRef on AutoDisposeProviderRef<ExerciseAnalytics> {
  /// The parameter `exerciseId` of this provider.
  String get exerciseId;
}

class _ExerciseAnalyticsProviderElement
    extends AutoDisposeProviderElement<ExerciseAnalytics>
    with ExerciseAnalyticsRef {
  _ExerciseAnalyticsProviderElement(super.provider);

  @override
  String get exerciseId => (origin as ExerciseAnalyticsProvider).exerciseId;
}

String _$analyticsNotifierHash() => r'0f6ee7c08bfc62ab422f045c1ae4f2f63eaae3aa';

/// See also [AnalyticsNotifier].
@ProviderFor(AnalyticsNotifier)
final analyticsNotifierProvider =
    NotifierProvider<AnalyticsNotifier, AnalyticsState>.internal(
      AnalyticsNotifier.new,
      name: r'analyticsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnalyticsNotifier = Notifier<AnalyticsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
