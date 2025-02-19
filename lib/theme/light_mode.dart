import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    fontFamily: 'Raleway',
    colorScheme: ColorScheme.light(
      primary: Color(0xFF00E676),
      secondary: Colors.grey.shade200,
      tertiary: Colors.white,
      inversePrimary: const Color(0xFF424242),
      shadow: Colors.grey.shade300,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      bodyLarge: const TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black),
      titleLarge: const TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black),
      bodyMedium: const TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black),
    ));
