abstract class MusicRepository {
  Future<String?> pickAndSaveMusic();
  Future<void> clearSavedMusic();
  Future<String?> getSavedMusicPath();
  Future<void> saveMusicPath(String path);
}
