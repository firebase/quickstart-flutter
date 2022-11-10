import 'package:authentication_quickstart/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

ColorScheme get firebaseColorScheme {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 245, 124, 0),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 44, 56, 74),
    onSecondary: Colors.white,
    error: Color.fromARGB(255, 255, 138, 101),
    onError: Colors.black,
    background: Color.fromARGB(255, 236, 239, 241),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  );
}

ThemeData get firebaseTheme {
  return ThemeData(
    colorScheme: firebaseColorScheme,
    scaffoldBackgroundColor: firebaseColorScheme.background,
    textTheme: TextTheme(
      titleLarge: titleTextStyle,
      titleMedium: titleMediumStyle,
    ),
  );
}

ColorScheme get firebaseDarkColorScheme {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 245, 124, 0),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 44, 56, 74),
    onSecondary: Colors.white,
    error: Color.fromARGB(255, 255, 138, 101),
    onError: Colors.black,
    background: Color.fromARGB(255, 236, 239, 241),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  );
}

ThemeData get firebaseDarkTheme {
  return ThemeData(
    colorScheme: firebaseColorScheme,
    scaffoldBackgroundColor: firebaseColorScheme.background,
    textTheme: TextTheme(
      titleLarge: titleTextStyle,
      titleMedium: titleMediumStyle,
    ),
  );
}
