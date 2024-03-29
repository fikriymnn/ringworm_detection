import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage

  Future<String> uploadImageToStorage(
      String childName, XFile filee, bool isPost) async {
    // creating location to our firebase storage
    final mimeType =
        lookupMimeType(filee.path); // Adjust this based on your file type
    SettableMetadata metadata = SettableMetadata(contentType: mimeType);

    Reference ref = _storage.ref().child(childName).child(filee.name);
    // if (isPost) {
    //   String id = const Uuid().v1();
    //   ref = ref.child(id);
    // }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(File(filee.path), metadata);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadImageToStorage2(
      String childName, XFile filee, bool isPost) async {
    // creating location to our firebase storage
    final mimeType =
        lookupMimeType(filee.path); // Adjust this based on your file type
    SettableMetadata metadata = SettableMetadata(contentType: mimeType);

    Reference ref = _storage.ref().child(childName).child(filee.name);
    // if (isPost) {
    //   String id = const Uuid().v1();
    //   ref = ref.child(id);
    // }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(File(filee.path), metadata);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
