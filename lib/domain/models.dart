enum DistanceUnit { km, miles }
enum MapMode { people, activities, both }
enum VerificationType { photo, governmentId, voice }
enum VerificationStatus { required, pending, approved, rejected }
enum StoryPrivacy { public, connections, private }

a class Profile { final String id; final String name; final int age; final String approximateLocation; final String pronouns; final String lookingFor; final List<String> desires; final List<String> interests; final String bio; final bool photoVerified; final bool idVerified; final bool voiceVerified; final List<String> photos; const Profile({required this.id,required this.name,required this.age,required this.approximateLocation,required this.pronouns,required this.lookingFor,required this.desires,required this.interests,required this.bio,required this.photoVerified,required this.idVerified,required this.voiceVerified,required this.photos}); }

class Activity { final String id; final String title; final String description; final String category; final String approximateLocation; final DateTime startsAt; final Duration duration; final int maxParticipants; final int participants; final bool isPrivate; const Activity({required this.id,required this.title,required this.description,required this.category,required this.approximateLocation,required this.startsAt,required this.duration,required this.maxParticipants,required this.participants,required this.isPrivate}); }

class Verification { final VerificationType type; final VerificationStatus status; const Verification({required this.type, required this.status}); }
