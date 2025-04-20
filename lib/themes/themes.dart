import 'package:flutter/material.dart';

class Themes {
  static ThemeData customLightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0XFF049977),

    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0XFFFBFBFB),
      color: Color(0XFFFBFBFB),
      iconTheme: IconThemeData(color: Color(0XFFFBFBFB)),
      titleTextStyle: TextStyle(
        color: Color(0XFFFBFBFB),
        fontSize: 20,
        fontFamily: 'IBMPlexSansArabic', // 👈 Added
      ),
    ),

    scaffoldBackgroundColor: Color(0XFFFBFBFB),

    iconTheme: const IconThemeData(color: Color(0XFFFFFFFF)),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
      bodyMedium: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
      bodySmall: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
      titleLarge: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
      titleMedium: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
      titleSmall: TextStyle(
        color: Color(0XFF000000),
        fontFamily: 'IBMPlexSansArabic',
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFF049977)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFF049977)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0XFF049977),
        foregroundColor: Color(0XFFFBFBFB),
        textStyle: const TextStyle(fontFamily: 'IBMPlexSansArabic'), // 👈 Added
      ),
    ),

    drawerTheme: const DrawerThemeData(backgroundColor: Color(0XFFFBFBFB)),
  );
}
