import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ringworm_detection/screens/chat/chatting.dart';

import '../../Components/snackBar.dart';
import '../../constraints.dart';
import '../../model/DocterModel.dart';
import '../../navigationDrawer/navigationDrawerDoctor.dart';

class ChatScreenDoctor extends StatefulWidget {
  ChatScreenDoctor({super.key, required this.doctorModel});
  DoctorModel doctorModel;

  @override
  State<ChatScreenDoctor> createState() => _ChatScreenDoctorState();
}

class _ChatScreenDoctorState extends State<ChatScreenDoctor> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavigatorDrawerDoctor(),
      appBar: AppBar(
        title: const Text("Ringworm Disease Detection"),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('akun')
                          .doc(widget.doctorModel.uid)
                          .collection('messages')
                          .orderBy("last_date", descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length < 1) {
                            return Center(
                              child: Text("Belum Ada Chat"),
                            );
                          }

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                var friendId = snapshot.data.docs[index].id;
                                var lastMsg =
                                    snapshot.data.docs[index]['last_msg'];

                                bool isMe = snapshot.data.docs[index]
                                        ['sender_id'] ==
                                    widget.doctorModel.uid;
                                var last = snapshot
                                    .data.docs[index]['last_date']
                                    .toDate();

                                String messageType =
                                    snapshot.data.docs[index]['type'];
                                bool messageSeenMe =
                                    snapshot.data.docs[index]['isSeen'];
                                bool messageSeenFriend =
                                    snapshot.data.docs[index]['isSeen'] ==
                                        friendId;

                                Widget messageWidget = Container();
                                Widget messageSeenWidgetMe = Container();
                                Widget messageSeenWidgetfriend = Container();

                                switch (messageSeenMe) {
                                  case false:
                                    messageSeenWidgetMe = Container(
                                      height: 20,
                                      width: 20,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPrimaryColor),
                                      child: Center(
                                          child: Text("1",
                                              style: GoogleFonts.rubik(
                                                  textStyle: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                    );

                                    break;

                                  case true:
                                    messageSeenWidgetMe = Container();

                                    break;
                                }

                                switch (messageSeenFriend) {
                                  case false:
                                    messageSeenWidgetfriend = Container(
                                      height: 20,
                                      width: 20,
                                      child: Icon(
                                        Icons.done_all,
                                        color: Colors.grey,
                                      ),
                                    );

                                    break;

                                  case true:
                                    messageSeenWidgetfriend = Container(
                                      height: 20,
                                      width: 20,
                                      child: Icon(
                                        Icons.done_all,
                                        color: kPrimaryColor,
                                      ),
                                    );

                                    break;
                                }

                                switch (messageType) {
                                  case 'text':
                                    messageWidget = Container(
                                      height: 18,
                                      width: 300,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "$lastMsg",
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    );
                                    break;

                                  case 'img':
                                    messageWidget = Container(
                                      height: 18,
                                      width: 300,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            "Foto",
                                            style: GoogleFonts.rubik(
                                                textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;
                                }

                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('akun')
                                      .doc(friendId)
                                      .get(),
                                  builder:
                                      (context, AsyncSnapshot asyncSnapshot) {
                                    if (asyncSnapshot.hasData) {
                                      var friend = asyncSnapshot.data;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('akun')
                                                  .doc(widget.doctorModel.uid)
                                                  .collection('messages')
                                                  .doc(friend['uid'])
                                                  .update({"isSeen": true});
                                            } on FirebaseException catch (error) {
                                              showSnackBar(
                                                  context, error.message!);
                                            } catch (error) {
                                              showSnackBar(
                                                  context, error.toString());
                                            } finally {}

                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chatting(
                                                          img: "",
                                                          myName: widget
                                                              .doctorModel.nama,
                                                          // fcmtoken:
                                                          //     friend['fcmtoken'],
                                                          currentUser: widget
                                                              .doctorModel.uid,
                                                          friendId:
                                                              friend['uid'],
                                                          friendName:
                                                              friend['nama'],
                                                          friendEmail:
                                                              friend['email'],
                                                          friendImage: friend[
                                                                      'img']
                                                                  .toString()
                                                                  .isEmpty
                                                              ? 'https://i.stack.imgur.com/l60Hf.png'
                                                              : friend['img'],
                                                          myImage: widget
                                                                  .doctorModel
                                                                  .img
                                                                  .toString()
                                                                  .isEmpty
                                                              ? 'https://i.stack.imgur.com/l60Hf.png'
                                                              : widget
                                                                  .doctorModel
                                                                  .img,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5, bottom: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: kPrimaryColor),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(2, 2))
                                                  ]),
                                              height: 72,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 24, right: 24),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(friend[
                                                                      'img']
                                                                  .toString()
                                                                  .isEmpty
                                                              ? 'https://i.stack.imgur.com/l60Hf.png'
                                                              : friend['img']),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 15),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 21,
                                                                width: 300,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      friend[
                                                                          'nama'],
                                                                      style: GoogleFonts.rubik(
                                                                          textStyle: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              messageWidget
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              DateFormat.jm()
                                                                  .format(last),
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            SizedBox(height: 5),
                                                            isMe
                                                                ? messageSeenWidgetfriend
                                                                : messageSeenWidgetMe
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return LinearProgressIndicator();
                                  },
                                );
                              });
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
