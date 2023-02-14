import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextModel {
  double? x, y;
  String? text;
  String? author;
  Color? backgroundColors = Colors.green;
  TextStyle? textStyle = GoogleFonts.alatsi();
  double? rotationSliderValue = 0.0;
  // Color? color;
  // double? fontSize;
  Color? strokeColors = Colors.transparent;
  double? strokeWidth;
  double? backgroundOpicity = 0.0;
  Color? backgroundShadow = Colors.white;
  double? backgroundCurve = 0.0;

  double blurSliderValue = 0.0;
  double xAxisSliderValue = 10.0;
  double byAxisSliderValue = 0.0;

  // var fonts;

  TextModel({
    this.x,
    this.y,
    this.text,
    this.author,
    this.textStyle,
    this.backgroundColors,
    this.backgroundCurve,
    this.backgroundShadow,
    this.backgroundOpicity,
    this.rotationSliderValue,
    this.strokeColors,
    this.strokeWidth,

    // this.color,
    // this.fontSize,
    // this.strokeColors,
    // this.strokeWidth,
    // this.fonts,
  });
}
