import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ringworm_detection/screens/chat/chatScreenDoctor.dart';

import '../../model/DocterModel.dart';

class ChatValidasiDoctor extends StatefulWidget {
  const ChatValidasiDoctor({super.key});
  static const String routName = '/homeDoctor';

  @override
  State<ChatValidasiDoctor> createState() => _ChatValidasiDoctorState();
}

class _ChatValidasiDoctorState extends State<ChatValidasiDoctor> {
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
        return ChatScreenDoctor(doctorModel: doctorModel);
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
