import 'package:flutter/material.dart';

class AppTheme {
  static const accent = Color(0xff53B175);
  static const bgMain = Color(0xffffffff);
  static const bgSecondary = Color(0xff7C7C7C);
  static const txtMain = Color(0xff181725);
  static const txtSecondary = Color(0xff7C7C7C);
  static const brdMain = Color(0xff7C7C7C);
  static const error = Color(0xffD32F2F);

  ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // primaryColor: primaryColor,
      // primarySwatch: primaryColor,
      // scaffoldBackgroundColor: bgMain,
      // cardColor: bgMain,
      // appBarTheme: const AppBarTheme(color: bgMain),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: txtMain,
        ),
        displayMedium: TextStyle(
          color: txtMain,
        ),
        displaySmall: TextStyle(
          color: txtMain,
        ),
        headlineLarge: TextStyle(
          color: txtMain,
        ),
        headlineMedium: TextStyle(
          color: txtMain,
        ),
        headlineSmall: TextStyle(
          color: txtMain,
        ),
        titleLarge: TextStyle(
          color: txtMain,
        ),
        titleMedium: TextStyle(
          color: txtMain,
        ),
        titleSmall: TextStyle(
          color: txtMain,
        ),
        bodyLarge: TextStyle(
          color: txtMain,
        ),
        bodyMedium: TextStyle(
          color: txtMain,
        ),
        bodySmall: TextStyle(
          color: txtMain,
        ),
      ),
      disabledColor: txtMain,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: accent,
        onPrimary: accent,
        secondary: txtMain,
        onSecondary: txtMain,
        error: error,
        onError: error,
        surface: bgMain,
        onSurface: bgMain,
        surfaceTint: Colors.transparent,
        onSurfaceVariant: Colors.black,
        surfaceContainerLow: accent,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
      ),
    );
  }

  MaterialColor get primaryColor => MaterialColor(
        accent.value,
        _primaryColorCodes,
      );

  late final Map<int, Color> _primaryColorCodes = {
    50: accent.withOpacity(.1),
    100: accent.withOpacity(.2),
    200: accent.withOpacity(.3),
    300: accent.withOpacity(.4),
    400: accent.withOpacity(.5),
    500: accent.withOpacity(.6),
    600: accent.withOpacity(.7),
    700: accent.withOpacity(.8),
    800: accent.withOpacity(.9),
    900: accent,
  };
}
