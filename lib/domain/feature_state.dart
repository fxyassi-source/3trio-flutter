class FeatureState {
  final bool isPremium;
  final int likesUsedLast24h;
  final bool incognito;
  final bool mapVisible;
  final bool haptics;
  final bool nearbyNotifications;
  final bool pushNotifications;
  final bool privatePhotos;
  final bool hiddenBio;
  final bool oneViewMedia;
  const FeatureState({this.isPremium=false,this.likesUsedLast24h=0,this.incognito=false,this.mapVisible=true,this.haptics=true,this.nearbyNotifications=true,this.pushNotifications=true,this.privatePhotos=true,this.hiddenBio=true,this.oneViewMedia=true});
  bool get canLike => isPremium || likesUsedLast24h < 100;
  FeatureState copyWith({bool? isPremium,int? likesUsedLast24h,bool? incognito,bool? mapVisible,bool? haptics,bool? nearbyNotifications,bool? pushNotifications,bool? privatePhotos,bool? hiddenBio,bool? oneViewMedia}) => FeatureState(isPremium:isPremium??this.isPremium,likesUsedLast24h:likesUsedLast24h??this.likesUsedLast24h,incognito:incognito??this.incognito,mapVisible:mapVisible??this.mapVisible,haptics:haptics??this.haptics,nearbyNotifications:nearbyNotifications??this.nearbyNotifications,pushNotifications:pushNotifications??this.pushNotifications,privatePhotos:privatePhotos??this.privatePhotos,hiddenBio:hiddenBio??this.hiddenBio,oneViewMedia:oneViewMedia??this.oneViewMedia);
}
