import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'Components/snackBar.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? myDocument;

  static updateSend(String myId, String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(myId)
          .collection('messages')
          .doc(friendId)
          .update({"isSeen": true});
    } catch (e) {
      print("error is $e");
    }
  }

  static deleteMessage(String myId, String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(myId)
          .collection('messages')
          .doc(friendId)
          .delete();

      await FirebaseFirestore.instance
          .collection('akun')
          .doc(friendId)
          .collection('messages')
          .doc(myId)
          .delete();
    } catch (e) {
      print("error is $e");
    }
  }

  createNotificationChat(
    String recUid,
    String friendImage,
    String myName,
  ) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(recUid)
        .collection("myNotification")
        .add({
      'message': "Mengirim sebuah pesan",
      'image': friendImage,
      'name': myName,
      'judul': "chat",
      'type': "chat",
      'time': DateTime.now()
    });
  }

  void setMessageSeen(
    BuildContext context,
    String reciverUserId,
    String messageId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(reciverUserId)
          .collection('chats')
          .doc(messageId)
          .update({
        "isSeen": true,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(reciverUserId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("chats")
          .doc(messageId)
          .update({
        "isSeen": true,
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
