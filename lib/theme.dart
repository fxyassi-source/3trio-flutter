import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const navy = Color(0xFF071633);
const navy2 = Color(0xFF0A1B3F);
const red = Color(0xFFE53935);
const ink = Color(0xFF05070D);
const offWhite = Color(0xFFF5F5F5);

ThemeData buildThreeTrioTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: ink,
    colorScheme: ColorScheme.fromSeed(seedColor: red, brightness: Brightness.dark, surface: navy),
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    dividerColor: Colors.white12,
    cardColor: navy,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
  );
}
