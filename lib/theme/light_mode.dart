import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    fontFamily: 'Raleway',
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade200,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade800,
      shadow: Colors.grey.shade300,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade600),
      bodyLarge: const TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black),
      titleLarge: const TextStyle(
          fontFamily: 'CaviarDreams',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black),
    ));
