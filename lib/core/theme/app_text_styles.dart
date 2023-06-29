import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Styles class holding app text styles
class AppTextStyles {
  /// Font family string
  static final TextStyle _textStyle = GoogleFonts.montserrat();

  /// Text style for large body text
  static TextStyle bodyLg = _textStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );

  /// Text style for body text
  static TextStyle body = _textStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Text style for small body text
  static TextStyle bodySm = _textStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  /// Text style for extra small body text
  static TextStyle bodyXs = _textStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w300,
  );

  /// Text style for heading 1 text
  static TextStyle h1 = _textStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  /// Text style for heading 2 text
  static TextStyle h2 = _textStyle.copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );

  /// Text style for heading 3 text
  static TextStyle h3 = _textStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  /// Text style for heading 4 text
  static TextStyle h4 = _textStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}
