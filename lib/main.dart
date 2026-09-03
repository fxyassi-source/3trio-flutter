import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens.dart';

void main() => runApp(const ThreeTrioApp());

class ThreeTrioApp extends StatelessWidget {
  const ThreeTrioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3TRIO',
      debugShowCheckedModeBanner: false,
      theme: buildThreeTrioTheme(),
      home: const AgeGateScreen(),
    );
  }
}
