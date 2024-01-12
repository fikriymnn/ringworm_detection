// ignore: file_names
import 'package:ringworm_detection/screens/editProfile/editProfile.dart';
import 'package:ringworm_detection/screens/editProfile/editProfileDoctor.dart';
import 'package:ringworm_detection/screens/history/history.dart';

import 'package:ringworm_detection/screens/login/login.dart';
import 'package:ringworm_detection/screens/forget_password/forget_password.dart';
import 'package:ringworm_detection/screens/verifikasi/verifikasi.dart';

import '../screens/AboutDiseases/aboutdiseases.dart';
import '../screens/Aboutus/aboutcreaters.dart';
import '../screens/Introduction/intro.dart';
import '../screens/Introduction/introDoctor.dart';
import '../screens/MainScreen/mainScreen.dart';
import '../screens/DoandDont/Doees.dart';
import '../screens/chat/chatValidasiDoctor.dart';
import '../screens/registrasi/registrasi.dart';
import '../screens/registrasi/registrasiDoctor.dart';
import '../validasi.dart';

class PageRoutes {
  static const String home = MainScreen.routName;
  static const String dodont = Dos.routeName;
  static const String intro = Intro.routeName;
  static const String aboutdis = AboutDisease.routeName;
  static const String aboutus = AboutUs.routeName;
  static const String login = LoginScreens.routName;
  static const String registrasi = RegistrasiScreens.routName;
  static const String history = HistoryScreens.routName;
  static String homeDoctor = ChatValidasiDoctor.routName;
  static const String introDoctor = IntroDoctor.routeName;
  static const String registrasiDoctor = RegistrasiScreensDoctor.routeName;
  static String Validasi = ValidasiScreens.routeName;
  static String editProfile = EditProfile.routeeName;
  static String editProfileDoctor = EditProfileDoctor.routeeName;
  static String verifikasiEmail = VerifikasiScreen.routName;
  static String ForgetPassword = ForgetPasswordScreen.routeName;
}
