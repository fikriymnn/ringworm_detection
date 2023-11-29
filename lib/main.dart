import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ringworm_detection/screens/editProfile/editProfile.dart';
import 'package:ringworm_detection/screens/editProfile/editProfileDoctor.dart';
import 'package:ringworm_detection/screens/history/history.dart';
import 'package:ringworm_detection/screens/listDoctor/listDoctorPage.dart';
import 'package:ringworm_detection/screens/login/login.dart';
import 'package:ringworm_detection/screens/registrasi/registrasi.dart';
import 'package:ringworm_detection/validasi.dart';
import 'routes/pageRoute.dart';
import 'screens/AboutDiseases/aboutdiseases.dart';
import 'screens/Aboutus/aboutcreaters.dart';
import 'screens/Introduction/intro.dart';
import 'screens/DoandDont/Doees.dart';
import 'screens/Introduction/introDoctor.dart';
import 'screens/MainScreen/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/chat/chatValidasiDoctor.dart';
import 'screens/registrasi/registrasiDoctor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const Intro();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreens();
          }),
      routes: {
        PageRoutes.home: (context) => const MainScreen(),
        PageRoutes.dodont: (context) => const Dos(),
        PageRoutes.intro: (context) => const Intro(),
        PageRoutes.aboutdis: (context) => const AboutDisease(),
        PageRoutes.aboutus: (context) => const AboutUs(),
        PageRoutes.login: (context) => const LoginScreens(),
        PageRoutes.registrasi: (context) => const RegistrasiScreens(),
        PageRoutes.history: (context) => const HistoryScreens(),
        PageRoutes.homeDoctor: (context) => ChatValidasiDoctor(),
        PageRoutes.introDoctor: (context) => const IntroDoctor(),
        PageRoutes.Validasi: (context) => const ValidasiScreens(),
        PageRoutes.registrasiDoctor: (context) =>
            const RegistrasiScreensDoctor(),
        PageRoutes.editProfile: (context) => const EditProfile(),
        PageRoutes.editProfileDoctor: (context) => const EditProfileDoctor()
      },
    );
  }
}


/*
Important link : https://www.thirdrocktechkno.com/blog/how-to-implement-navigation-drawer-in-flutter/

*/