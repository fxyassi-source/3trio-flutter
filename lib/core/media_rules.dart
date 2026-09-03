class MediaRules {
  static const int maxProfilePhotos = 5;
  static const int maxShortVideoSeconds = 60;
  static const bool oneViewCannotReopen = true;
  static const bool privateMediaExcludedFromDiscovery = true;

  static bool canAddProfilePhoto(int currentCount) => currentCount < maxProfilePhotos;
}
