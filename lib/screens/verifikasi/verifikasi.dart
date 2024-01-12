import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ringworm_detection/Components/snackBar.dart';
import 'package:ringworm_detection/constraints.dart';
import 'package:ringworm_detection/routes/pageRoute.dart';
import 'package:ringworm_detection/screens/Introduction/intro.dart';
import 'package:ringworm_detection/screens/verifikasi/verifikasi_doctor.dart';

class VerifikasiScreen extends StatefulWidget {
  const VerifikasiScreen({super.key});
  static const String routName = '/verifikasi';

  @override
  State<VerifikasiScreen> createState() => _VerifikasiScreenState();
}

class _VerifikasiScreenState extends State<VerifikasiScreen> {
  bool isEmailVerify = false;
  bool canResentEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerify) {
      sendVerifikasiEmail();

      timer =
          Timer.periodic(Duration(seconds: 3), (timer) => checkEmailVerify());
    }
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerify() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerify) timer?.cancel();
  }

  Future sendVerifikasiEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResentEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResentEmail = true);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  String? Role;
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;

  Future<void> getUserData() async {
    try {
      setState(() {
        loading = true;
      });
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('akun')
          .doc(user!.uid)
          .get();
      if (userDoc == null) {
        setState(() {
          loading = false;
        });
        return;
      } else {
        Role = userDoc.get('role');
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerify
        ? loading == true
            ? Scaffold()
            : Role == "user"
                ? Intro()
                : Role == "doctor"
                    ? VerifikasiSertifikatScreen()
                    : Scaffold(
                        appBar: AppBar(
                          title: Text(
                            "Email Verification",
                            style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                          backgroundColor: kPrimaryColor,
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Terjadi Kesalahan Pada Server Kami",
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      minimumSize: Size.fromHeight(50)),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        PageRoutes.login, (route) => false);
                                  },
                                  icon: Icon(
                                    Icons.email,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Kembali Ke Login",
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500)),
                                  )),
                              SizedBox(
                                height: 24,
                              ),
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      minimumSize: Size.fromHeight(50)),
                                  onPressed: () {
                                    getUserData();
                                  },
                                  icon: Icon(
                                    Icons.refresh_outlined,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  label: loading == false
                                      ? Text(
                                          "Refresh",
                                          style: GoogleFonts.rubik(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                        )),
                            ],
                          ),
                        ),
                      )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Email Verification",
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
              backgroundColor: kPrimaryColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A verification email has been sent to your email",
                    style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: canResentEmail
                              ? kPrimaryColor
                              : Colors.black.withOpacity(0.10),
                          minimumSize: Size.fromHeight(50)),
                      onPressed: canResentEmail ? sendVerifikasiEmail : null,
                      icon: Icon(
                        Icons.email,
                        size: 32,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Resent Email",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50)),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, PageRoutes.login, (route) => false);
                      },
                      child: Text(
                        "Cancle",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                      ))
                ],
              ),
            ),
          );
  }
}
