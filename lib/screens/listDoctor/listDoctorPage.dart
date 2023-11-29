import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ringworm_detection/model/userModel.dart';
import 'package:ringworm_detection/screens/chat/chatScreenDoctor.dart';
import 'package:ringworm_detection/screens/listDoctor/listDoctor.dart';

import '../../model/DocterModel.dart';

class ListDoctorPage extends StatefulWidget {
  ListDoctorPage({super.key, required this.img});
  String img;
  static const String routName = '/homeDoctor';

  @override
  State<ListDoctorPage> createState() => _ListDoctorPageState();
}

class _ListDoctorPageState extends State<ListDoctorPage> {
  @override
  Widget build(BuildContext context) {
    Future<Widget> chatPage() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('akun')
            .doc(user.uid)
            .get();
        DoctorModel doctorModel = DoctorModel.fromSnap(userData);
        return ListDoctor(doctorModel: doctorModel, img: widget.img);
      } else {
        return Container();
      }
    }

    return FutureBuilder(
        future: chatPage(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        });
  }
}
