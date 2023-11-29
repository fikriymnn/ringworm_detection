import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constraints.dart';
import '../../firestore_methods.dart';
import '../../global_methods.dart';
import '../../utils/utils.dart';
import '../../widget/message_text_fild.dart';
import '../../widget/single_img.dart';
import '../../widget/single_message.dart';

class Chatting extends StatefulWidget {
  final String currentUser;
  final String friendId;
  final String img;
  final String friendEmail;
  final String friendName;
  final String myImage;
  final String friendImage;
  // final String fcmtoken;
  final String myName;

  Chatting({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendEmail,
    required this.friendImage,
    required this.img,
    // required this.fcmtoken,
    required this.myName,
    required this.myImage,
  });

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final ScrollController messageController = ScrollController();
  bool isLoading = false;
  bool _isLoading = false;
  bool isSeen = false;
  String image = "";
  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    image = widget.img;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.friendImage),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 21,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.friendName,
                                  style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 18,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.friendEmail,
                                  style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                  context: context,
                  subtitle:
                      "Yakin menghapus percakapan dengan ${widget.friendName}?",
                  title: "Hapus Percakapan",
                  fct: () async {
                    await FirebaseFirestore.instance
                        .collection('akun')
                        .doc(widget.currentUser)
                        .collection('messages')
                        .doc(widget.friendId)
                        .delete();

                    final collection = await FirebaseFirestore.instance
                        .collection('akun')
                        .doc(widget.currentUser)
                        .collection('messages')
                        .doc(widget.friendId)
                        .collection('chats')
                        .get();

                    final batch = FirebaseFirestore.instance.batch();

                    for (final doc in collection.docs) {
                      batch.delete(doc.reference);
                    }

                    return batch.commit();
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sedang memuat data',
                  style: TextStyle(color: kPrimaryColor),
                ),
                CircularProgressIndicator(
                  color: kPrimaryColor,
                )
              ],
            )
          : Column(
              children: [
                Expanded(
                    child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("akun")
                          .doc(widget.currentUser)
                          .collection('messages')
                          .doc(widget.friendId)
                          .collection('chats')
                          .orderBy("date", descending: false)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          FireStoreMethods.updateSend(
                              widget.currentUser, widget.friendId);
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            messageController.jumpTo(
                                messageController.position.maxScrollExtent);
                          });

                          return isLoading
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sedang memuat data',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  controller: messageController,
                                  itemCount: snapshot.data.docs.length,
                                  reverse: false,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    bool isMe = snapshot.data.docs[index]
                                            ['senderId'] ==
                                        widget.currentUser;
                                    String messageType =
                                        snapshot.data.docs[index]['type'];
                                    Widget messageWidget = Container();

                                    switch (messageType) {
                                      case 'text':
                                        messageWidget = SingleMessage(
                                          message: snapshot.data.docs[index]
                                              ['message'],
                                          isMe: isMe,
                                          date: snapshot
                                              .data.docs[index]['date']
                                              .toDate(),
                                        );
                                        break;

                                      case 'img':
                                        messageWidget = SingleImage(
                                            message: snapshot.data.docs[index]
                                                ['message'],
                                            isMe: isMe,
                                            date: snapshot
                                                .data.docs[index]['date']
                                                .toDate());
                                        break;
                                    }

                                    return messageWidget;
                                  });
                        }
                        return Center(
                            child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ));
                      }),
                )),
                image == ""
                    ? MessageTextFieldDoctor(
                        widget.currentUser,
                        widget.friendId,
                        // widget.fcmtoken,
                        widget.friendImage,
                        widget.friendName,
                        widget.myName,
                        widget.myImage)
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 270,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(widget.img),
                                  )),
                            ),
                            InkWell(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('akun')
                                        .doc(widget.currentUser)
                                        .collection('messages')
                                        .doc(widget.friendId)
                                        .collection('chats')
                                        .add({
                                      "senderId": widget.currentUser,
                                      "receiverId": widget.friendId,
                                      "message": widget.img,
                                      "isSeen": isSeen,
                                      "type": "img",
                                      "date": DateTime.now(),
                                    }).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('akun')
                                          .doc(widget.currentUser)
                                          .collection('messages')
                                          .doc(widget.friendId)
                                          .set({
                                        "last_date": DateTime.now(),
                                        "sender_id": widget.currentUser,
                                        "friend_id": widget.friendId,
                                        "last_msg": widget.img,
                                        "isSeen": isSeen,
                                        "type": "img",
                                      });
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('akun')
                                        .doc(widget.friendId)
                                        .collection('messages')
                                        .doc(widget.currentUser)
                                        .collection("chats")
                                        .add({
                                      "senderId": widget.currentUser,
                                      "receiverId": widget.friendId,
                                      "message": widget.img,
                                      "isSeen": isSeen,
                                      "type": "img",
                                      "date": DateTime.now(),
                                    }).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('akun')
                                          .doc(widget.friendId)
                                          .collection('messages')
                                          .doc(widget.currentUser)
                                          .set({
                                        "last_msg": widget.img,
                                        "sender_id": widget.currentUser,
                                        "friend_id": widget.friendId,
                                        "isSeen": isSeen,
                                        "last_date": DateTime.now(),
                                        "type": "img"
                                      });
                                    });

                                    setState(() {
                                      image = "";
                                    });
                                    // FireStoreMethods()
                                    //     .createNotificationChat(
                                    //   widget.friendId,
                                    //   widget.myImage,
                                    //   widget.myName,
                                    // );

                                    // String myNamee = widget.myName;

                                    // LocalNotificationService.sendNotification(
                                    //     message: "Foto",
                                    //     title:
                                    //         " $myNamee mengirim anda sebuah pesan",
                                    //     token: widget.fcmtoken);
                                  } catch (err) {
                                    GlobalMethods.errorDialog(
                                        subtitle: err.toString(),
                                        context: context);
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.canPop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: _isLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  'Kirim Foto',
                                                  style: GoogleFonts.rubik(
                                                      textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                                ))),
                                ))
                          ],
                        ),
                      ),
              ],
            ),
    );
  }
}
