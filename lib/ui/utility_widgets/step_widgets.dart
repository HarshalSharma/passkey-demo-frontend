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
  final Function()? onTap;

  const StepButton(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        }
        return AppConstants.theme.colorScheme.secondary;
      })),
      onPressed: onTap,
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
  DateTime? timestamp;
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
    if (stepOutput.output == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StatusIndicatorWidget(
            successful: stepOutput.successful,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stepOutput.output != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
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
                    getFormattedTimestamp(),
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

  String getFormattedTimestamp() {
    var formattedTimestamp = "${stepOutput.timestamp!.year.toString()}"
        "-${stepOutput.timestamp!.month.toString().padLeft(2, '0')}"
        "-${stepOutput.timestamp!.day.toString().padLeft(2, '0')} "
        "${stepOutput.timestamp!.hour.toString().padLeft(2, '0')}-"
        "${stepOutput.timestamp!.minute.toString().padLeft(2, '0')}";
    return formattedTimestamp;
  }
}

class StatusIndicatorWidget extends StatelessWidget {
  final bool? successful;

  const StatusIndicatorWidget({super.key, required this.successful});

  @override
  Widget build(BuildContext context) {
    if (successful == true) {
      return Icon(
        Icons.check,
        color: AppConstants.theme.colorScheme.secondary,
      );
    } else if (successful == false) {
      return const Icon(Icons.close, color: Colors.red);
    }
    return const SizedBox();
  }
}

class NumberedStep extends StatelessWidget {
  final String? number;
  final String? title;
  final String? description;
  final List<Widget>? children;

  const NumberedStep(
      {super.key,
      this.number,
      this.title,
      this.description,
      this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              number!,
              style: AppConstants.textTheme.bodyMedium,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title!,
                    style: AppConstants.textTheme.bodyMedium,
                    softWrap: true,
                  ),
                ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description!,
                    style: AppConstants.textTheme.bodyMedium,
                    softWrap: true,
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
    );
  }
}
