import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';

class BasicStep extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget>? children;

  const BasicStep(
      {super.key,
      required this.title,
      required this.description,
      this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ),
          if (children != null)
            for (var widget in children!)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget,
              )
        ],
      ),
    );
  }
}

class StepButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const StepButton(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
              AppConstants.theme.colorScheme.secondary)),
      onPressed: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class StepOutput {
  String? timestamp;
  String? output;
  bool? successful;

  StepOutput({this.timestamp, this.output, this.successful});
}

class StepOutputWidget extends StatelessWidget {
  final StepOutput stepOutput;

  const StepOutputWidget({
    super.key,
    required this.stepOutput,
  });

  @override
  Widget build(BuildContext context) {
    if(stepOutput.output == null) {
      return const SizedBox ();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: getStatusIcon(),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stepOutput.output != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    stepOutput.output!,
                    style: GoogleFonts.jetBrainsMono(
                        color: AppConstants.theme.colorScheme.secondary,
                        fontSize: 16),
                  ),
                ),
              if (stepOutput.timestamp != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    stepOutput.timestamp!,
                    style: GoogleFonts.jetBrainsMono(
                        color: Colors.black, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Icon getStatusIcon() {
    if (stepOutput.successful == true) {
      return Icon(
        Icons.check,
        color: AppConstants.theme.colorScheme.secondary,
      );
    }
    return const Icon(Icons.close, color: Colors.red);
  }
}

class NumberedStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final List<Widget>? children;

  const NumberedStep(
      {super.key,
      required this.number,
      required this.title,
      required this.description,
      this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              number,
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
                if (children != null)
                  for (var widget in children!)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget,
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
