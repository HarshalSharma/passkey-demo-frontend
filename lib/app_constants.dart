import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static ThemeData theme = ThemeData(
      primaryColor: const Color(0xFFFFDE03),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo,
        accentColor: const Color(0xFF0336FF),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF));

  static TextTheme textTheme = TextTheme(
      titleLarge: GoogleFonts.openSansCondensed(
          fontWeight: FontWeight.bold, fontSize: 28),
      titleMedium: GoogleFonts.openSansCondensed(
          fontWeight: FontWeight.bold, fontSize: 26),
      titleSmall: GoogleFonts.openSansCondensed(
          fontWeight: FontWeight.bold, fontSize: 21),
      bodyLarge: GoogleFonts.alike(fontSize: 24),
      bodyMedium: GoogleFonts.alike(fontSize: 21, height: 1.5),
      bodySmall: GoogleFonts.jetBrainsMono(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
          color: AppConstants.theme.colorScheme.secondary, fontSize: 18),
      labelMedium: GoogleFonts.jetBrainsMono(
          color: AppConstants.theme.colorScheme.secondary, fontSize: 14),

  );

  static String defaultServer = "https://fairly-fun-osprey.ngrok-free.app";
}
