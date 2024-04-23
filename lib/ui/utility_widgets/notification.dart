import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_constants.dart';

class NotificationUtils {
  static notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppConstants.theme.primaryColor,
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
