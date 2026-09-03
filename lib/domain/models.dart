enum DistanceUnit { km, miles }
enum MapMode { people, activities, both }
enum VerificationType { photo, governmentId, voice }
enum VerificationStatus { required, pending, approved, rejected }
enum StoryPrivacy { public, connections, private }

class Profile {
  final String id, name, approximateLocation, pronouns, lookingFor, bio;
  final int age;
  final List<String> desires, interests, photos;
  final bool photoVerified, idVerified, voiceVerified;
  const Profile({required this.id, required this.name, required this.age, required this.approximateLocation, required this.pronouns, required this.lookingFor, required this.desires, required this.interests, required this.bio, required this.photoVerified, required this.idVerified, required this.voiceVerified, required this.photos});
}

class Activity {
  final String id, title, description, category, approximateLocation;
  final DateTime startsAt;
  final Duration duration;
  final int maxParticipants, participants;
  final bool isPrivate;
  const Activity({required this.id, required this.title, required this.description, required this.category, required this.approximateLocation, required this.startsAt, required this.duration, required this.maxParticipants, required this.participants, required this.isPrivate});
}

class Verification {
  final VerificationType type;
  final VerificationStatus status;
  const Verification({required this.type, required this.status});
}

class Story {
  final String id, authorId, mediaUrl;
  final StoryPrivacy privacy;
  final DateTime expiresAt;
  const Story({required this.id, required this.authorId, required this.mediaUrl, required this.privacy, required this.expiresAt});
}

class ChatMessage {
  final String id, senderId, text;
  final DateTime sentAt;
  final bool oneView, deleted;
  const ChatMessage({required this.id, required this.senderId, required this.text, required this.sentAt, this.oneView = false, this.deleted = false});
}
