enum SignInMethod { google, phone, apple }

class AuthSession {
  final String userId;
  final SignInMethod method;
  final bool verified;
  const AuthSession({required this.userId, required this.method, this.verified = false});
}
