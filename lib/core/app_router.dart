import 'package:flutter/material.dart';
import 'verification_flow.dart';

class AppRouter {
  static Route<dynamic> verification() => MaterialPageRoute(builder: (_) => const VerificationFlow());
}
