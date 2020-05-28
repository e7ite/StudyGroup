import 'package:flutter/material.dart';

final themeData = _theme();

ThemeData _theme() {
  final base = ThemeData.light();

  return base.copyWith(
    primaryColor: Color(0xFF437c90),
    brightness: Brightness.light,
    accentColor: Color(0xFF77af9c),
    secondaryHeaderColor: Colors.grey[600],
    hintColor: Colors.grey,
    dividerColor: Color(0xFF77af9c),
    scaffoldBackgroundColor: Colors.white,
    // Background color of bottom navbar
    canvasColor: Colors.grey[300],
    backgroundColor: Color(0xFF98c1d9),
    textTheme: _textTheme(base.textTheme),
    primaryTextTheme: _primTextTheme(base.primaryTextTheme),
    inputDecorationTheme: _inputDecorationTheme(base.inputDecorationTheme),
  );
}

TextTheme _primTextTheme(TextTheme base) {
  return base.copyWith(
    headline6: base.headline6
        .copyWith(
          fontSize: 29,
          letterSpacing: 1.0,
        )
        .apply(fontFamily: 'Rubik'),
  );
}

TextTheme _textTheme(TextTheme base) {
  return base
      .copyWith(
          bodyText2: TextStyle(color: Colors.black),
          headline5: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.white))
      .apply(fontFamily: 'Rubik');
}

InputDecorationTheme _inputDecorationTheme(InputDecorationTheme base) {
  return base.copyWith(
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    hintStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w100,
      fontSize: 12.0,
    ),
  );
}

var kBoxGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0XFF64b3f4),
      Color(0xFFc2e59c),
    ],
  ),
);
