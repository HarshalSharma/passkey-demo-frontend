import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';

class Loading extends StatelessWidget {
  final Widget? child;

  const Loading({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpinKitWave(
          size: 30,
          itemCount: 5,
          color: AppConstants.theme.colorScheme.secondary,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "loading",
            style: GoogleFonts.jetBrainsMono(color: AppConstants.theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
