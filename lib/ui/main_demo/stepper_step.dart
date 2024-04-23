import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepperStep {
  final int index;
  final bool isEnabled;
  final bool isPrevStepCompleted;
  final bool isSkippable;
  final Function(int index) onComplete;
  final String titleText;
  Widget? child;
  bool isCompleted;

  StepperStep(
    this.index, {
    required this.titleText,
    required this.onComplete,
    required this.isEnabled,
    required this.isPrevStepCompleted,
    this.isSkippable = false,
    this.isCompleted = false,
    this.child,
  });

  Widget get content => child != null ? child! : Container();

  bool get isActive => isPrevStepCompleted || isEnabled;

  Widget? get label => null;

  StepState get state => isCompleted ? StepState.complete : StepState.indexed;

  Widget? get subtitle => null;

  Widget get title => Text(
        titleText,
        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      );

  markCompleted() {
    isCompleted = true;
    onComplete(index);
  }

  markReset() {
    isCompleted = false;
  }

  setContent(Widget widget) {
    child = widget;
  }
}
