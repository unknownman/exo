abstract class MediaRepository {
  Future<String?> pickAndSaveMedia();
  Future<void> deleteMedia(String path);
}
