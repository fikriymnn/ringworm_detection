import 'package:flutter/material.dart';
import 'routes/pageRoute.dart';
import 'screens/AboutDiseases/aboutdiseases.dart';
import 'screens/Aboutus/aboutcreaters.dart';
import 'screens/Introduction/intro.dart';
import 'screens/DoandDont/Doees.dart';
import 'screens/MainScreen/mainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent[400],
      ),
      home: Intro(),
      routes: {
        PageRoutes.home: (context) => const MainScreen(),
        PageRoutes.dodont: (context) => const Dos(),
        PageRoutes.intro: (context) => const Intro(),
        PageRoutes.aboutdis: (context) => const AboutDisease(),
        PageRoutes.aboutus: (context) => const AboutUs(),
      },
    );
  }
}


/*
Important link : https://www.thirdrocktechkno.com/blog/how-to-implement-navigation-drawer-in-flutter/

*/