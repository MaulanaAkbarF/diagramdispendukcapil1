import 'package:flutter/material.dart';

class StyleApp {
  // Font Statis
  static const TextStyle smallTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mediumTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle semiLargeTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 23.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle largeTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 26.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle extraLargeTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 32.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle giantTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 40.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mediumInputTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(0, 0, 0, 1),
  );

  static const TextStyle largeInputTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(0, 0, 0, 1),
  );

  // Font dinamis
  static const TextStyle commonTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle boldTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle boldLargeTextStyle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  static TextStyle getTextStyle({
    bool isBold = false,
    Color? textColor,
    bool isItalic = false,
    double? customFontSize,
  }) {
    TextStyle textStyle = isBold ? boldTextStyle : commonTextStyle;

    if (textColor != null) {
      textStyle = textStyle.copyWith(color: textColor);
    }

    if (isItalic) {
      textStyle = textStyle.copyWith(fontStyle: FontStyle.italic);
    }

    if (customFontSize != null) {
      textStyle = textStyle.copyWith(fontSize: customFontSize);
    }

    return textStyle;
  }
}

