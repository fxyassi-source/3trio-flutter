class MapFilter {
  final double distanceKm;
  final int minAge;
  final int maxAge;
  final bool verifiedOnly;
  final bool onlineOnly;
  final List<String> genders;
  final List<String> sexualities;
  final List<String> desires;
  final List<String> interests;
  final List<String> activityCategories;
  const MapFilter({this.distanceKm = 25, this.minAge = 18, this.maxAge = 70, this.verifiedOnly = false, this.onlineOnly = false, this.genders = const [], this.sexualities = const [], this.desires = const [], this.interests = const [], this.activityCategories = const []});
}

class FavouritePlace {
  final String category;
  final String label;
  const FavouritePlace(this.category, this.label);
}

class CrossedPath {
  final String profileId;
  final String safeArea;
  final DateTime approximateTime;
  const CrossedPath({required this.profileId, required this.safeArea, required this.approximateTime});
}
