// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$musicRepositoryHash() => r'0d53d8bdd03c50988d8fe9e0b8731e37063323fb';

/// See also [musicRepository].
@ProviderFor(musicRepository)
final musicRepositoryProvider = AutoDisposeProvider<MusicRepository>.internal(
  musicRepository,
  name: r'musicRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$musicRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MusicRepositoryRef = AutoDisposeProviderRef<MusicRepository>;
String _$musicProviderHash() => r'04f0852e7c3d9e9cc860405f6d6485c5b332aeb1';

/// See also [MusicProvider].
@ProviderFor(MusicProvider)
final musicProviderProvider =
    NotifierProvider<MusicProvider, MusicState>.internal(
      MusicProvider.new,
      name: r'musicProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$musicProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MusicProvider = Notifier<MusicState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
