import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const ink = Color(0xFF0F0E0C);
  static const paper = Color(0xFFF5F0E8);
  static const paperDark = Color(0xFFEDE7D9);
  static const accent = Color(0xFFC8F542);
  static const muted = Color(0xFF8A8070);
  static const border = Color(0xFFD8D0C0);
  static const danger = Color(0xFFE84040);
  static const income = Color(0xFF22C55E);
  static const cardWhite = Color(0xFFFFFFFF);

  // category icon backgrounds
  static const catFood = Color(0xFFFEF3C7);
  static const catTransport = Color(0xFFEDE9FE);
  static const catEntertainment = Color(0xFFFCE7F3);
  static const catHealth = Color(0xFFDCFCE7);
  static const catOther = Color(0xFFEDE7D9);
}

class AppText {
  AppText._();

  static TextStyle serif(double size, {Color color = AppColors.ink}) =>
      GoogleFonts.dmSerifDisplay(fontSize: size, color: color);

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const small = TextStyle(fontSize: 11, color: AppColors.muted);

  static const tiny = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.muted,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      secondary: AppColors.accent,
      surface: AppColors.paper,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(),
  );
}
