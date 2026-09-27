import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const evergreen = Color(0xFF1D6657);
  static const ink = Color(0xFF193B35);
  static const apricot = Color(0xFFE77850);
  static const parchment = Color(0xFFF9F4ED);
  static const softGreen = Color(0xFFE7F0E9);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: evergreen,
      brightness: Brightness.light,
      primary: evergreen,
      secondary: apricot,
      surface: parchment,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: parchment,
      useMaterial3: true,
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.fraunces(
          fontSize: 64,
          height: .92,
          fontWeight: FontWeight.w700,
          letterSpacing: -3.5,
          color: ink,
        ),
        displayMedium: GoogleFonts.fraunces(
          fontSize: 48,
          height: .94,
          fontWeight: FontWeight.w700,
          letterSpacing: -2.2,
          color: ink,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 34,
          height: 1,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          color: ink,
        ),
        titleLarge: GoogleFonts.fraunces(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyLarge: GoogleFonts.dmSans(fontSize: 16, height: 1.6, color: ink),
        bodyMedium:
            GoogleFonts.dmSans(fontSize: 14, height: 1.55, color: ink),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: parchment,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: .75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD6DFD8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD6DFD8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: evergreen, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}