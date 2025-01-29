import 'package:flutter/material.dart';
import 'colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: darkGreen,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light().copyWith(
      background: Colors.white,
      primary: darkGreen,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: darkGreen,
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.dark().copyWith(
      background: Colors.grey[900],
      primary: darkGreen,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}

extension ThemeDataExtensions on ThemeData {
  Color get appBarColor => brightness == Brightness.light 
      ? Colors.white 
      : Colors.grey[850]!;
      
  Color get taskCardColor => brightness == Brightness.light 
      ? Colors.white 
      : Colors.grey[800]!;
} 