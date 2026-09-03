abstract interface class AuthService {
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInWithPhone(String phone);
  Future<void> signOut();
}

abstract interface class VerificationService {
  Future<void> startPhotoVerification();
  Future<void> submitGovernmentId();
  Future<void> startVoiceVerification();
}

abstract interface class LocationService {
  Future<void> requestPermission();
  Future<({double latitude, double longitude})?> currentLocation();
}

abstract interface class MessagingService {
  Stream<List<Object>> watchMessages(String conversationId);
  Future<void> sendText(String conversationId, String text, {bool oneView = false});
}

abstract interface class CallService {
  Future<void> startAudioCall(String conversationId);
  Future<void> startVideoCall(String conversationId);
  Future<void> endCall();
}

abstract interface class BillingService {
  Future<void> purchaseMonthly();
  Future<void> purchaseSixMonths();
  Future<void> purchaseYearly();
}
