import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ringworm_detection/constraints.dart';
import 'package:ringworm_detection/global_methods.dart';
import 'package:ringworm_detection/model/DocterModel.dart';
import 'package:ringworm_detection/model/userModel.dart';
import 'package:ringworm_detection/screens/chat/chatting.dart';

import '../../navigationDrawer/navigationDrawer.dart';

class ListDoctor extends StatefulWidget {
  ListDoctor({super.key, required this.img});

  final String img;

  @override
  State<ListDoctor> createState() => _ListDoctorState();
}

class _ListDoctorState extends State<ListDoctor> {
  User? user = FirebaseAuth.instance.currentUser;
  String id = "";
  String img = "";
  String name = "";

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  Future<void> getUserData() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('akun')
          .doc(user!.uid)
          .get();
      if (userDoc == null) {
        return;
      } else {
        name = userDoc.get('nama');
        img = userDoc.get('img');
        id = userDoc.get("uid");
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ringworm Disease Detection"),
      ),
      drawer: const NavigatorDrawer(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('akun')
            .where("role", isEqualTo: "doctor")
            .where('status', isEqualTo: "active")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("tidak ada Doctor"),
            );
          }
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs;

              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chatting(
                              img: widget.img,
                              myName: name,
                              // fcmtoken:
                              //     friend['fcmtoken'],
                              currentUser: id,
                              friendId: doc[index]['uid'],
                              friendName: doc[index]['nama'],
                              friendEmail: doc[index]['email'],
                              friendImage: doc[index]['img'].toString().isEmpty
                                  ? 'https://i.stack.imgur.com/l60Hf.png'
                                  : doc[index]['img'],
                              myImage: img == ""
                                  ? 'https://i.stack.imgur.com/l60Hf.png'
                                  : img,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Container(
                    height: 72,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(doc[index]["img"] == ""
                              ? 'https://i.stack.imgur.com/l60Hf.png'
                              : doc[index]["img"]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 21,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                (snapshot.data! as dynamic).docs[index]['nama'],
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
