import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/controllers/HomeController.dart';
import 'package:ohud/screens/HomeScreen.dart';
import 'package:ohud/screens/SignInScreen.dart';
import 'package:ohud/themes/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ohud App',
      locale: const Locale('ar'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: HomeBinding(),
      textDirection: TextDirection.rtl, // Set entire app to RTL
      theme: Themes.customLightTheme,
      home: SigninScreen(),
    );
  }
}
