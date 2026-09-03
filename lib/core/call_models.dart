enum CallType { audio, video }
enum CallStatus { ringing, connected, reconnecting, ended, missed }

class CallSession {
  final String id;
  final String peerId;
  final CallType type;
  final CallStatus status;
  final DateTime startedAt;
  const CallSession({required this.id, required this.peerId, required this.type, required this.status, required this.startedAt});
}
