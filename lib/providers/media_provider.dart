import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/media_repository_impl.dart';
import '../domain/repositories/media_repository.dart';

part 'media_provider.g.dart';

@riverpod
MediaRepository mediaRepository(MediaRepositoryRef ref) => MediaRepositoryImpl();
