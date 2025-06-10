import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    secondary:  Color.fromARGB(255, 0, 210, 190),
    onSecondary: Color(0xFFF2F4F5),
    secondaryFixed: Colors.grey.shade300,
    onSecondaryFixed: Colors.grey.shade300,
    onSecondaryFixedVariant: Colors.grey.shade300,
    tertiary: Colors.grey.shade300,
    secondaryContainer: Colors.grey.shade400,
    onSecondaryContainer: Colors.grey.shade400,
  )
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    secondary:  Color.fromARGB(255, 0, 210, 190),
    onSecondary: Color(0xFFF2F4F5),
    secondaryFixed: Colors.grey.shade900,
    onSecondaryFixed: Colors.grey.shade800,
    onSecondaryFixedVariant: const Color.fromARGB(255, 36, 36, 36),
    tertiary: const Color.fromARGB(255, 39, 39, 39),
    secondaryContainer: Colors.black,
    onSecondaryContainer: Colors.grey[900],
    )
);
