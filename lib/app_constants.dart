import 'package:flutter/material.dart';

class AppConstants {
  static ThemeData theme = ThemeData(
      primaryColor: const Color(0xFFFFDE03),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo,
        accentColor: const Color(0xFF0336FF),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF));
}
