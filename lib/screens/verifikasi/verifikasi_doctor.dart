import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ringworm_detection/Components/snackBar.dart';
import 'package:ringworm_detection/constraints.dart';
import 'package:ringworm_detection/routes/pageRoute.dart';
import 'package:ringworm_detection/screens/Introduction/intro.dart';

class VerifikasiSertifikatScreen extends StatefulWidget {
  const VerifikasiSertifikatScreen({super.key});
  static const String routName = '/verifikasi';

  @override
  State<VerifikasiSertifikatScreen> createState() =>
      _VerifikasiSertifikatScreenState();
}

class _VerifikasiSertifikatScreenState
    extends State<VerifikasiSertifikatScreen> {
  @override
  void initState() {
    // TODO: implement initState

    getUserData();
    super.initState();
  }

  String? status;
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
        status = userDoc.get('status');
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
  Widget build(BuildContext context) => status == "active"
      ? Intro()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              "Doctor Verification",
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
                  "Data Anda Sedang Di Periksa Oleh Admin, Mohon Tunggu!!",
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, PageRoutes.login, (route) => false);
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
        );
}
