import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'model/DocterModel.dart' as modelDoctor;

class AuthMethodsDoctor {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Signing Up User
  Future<String> signUpUser({
    required Timestamp createdAt,
    required String email,
    required String password,
    required String nama,
    required String alamat,
    required String noHp,
    required String alamatLink,
    required String sertifikat,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        modelDoctor.DoctorModel _user = modelDoctor.DoctorModel(
            createdAt: Timestamp.now(),
            uid: cred.user!.uid,
            nama: nama,
            email: email,
            role: "doctor",
            alamat: alamat,
            alamatLink: alamatLink,
            img: "",
            noHp: noHp,
            note: "",
            status: "non-active",
            sertifikat: sertifikat);

        // adding user in our database
        await _firestore
            .collection("akun")
            .doc(cred.user!.uid)
            .set(_user.toJson());
        // await ref
        //     .push()
        //     .set({"id": cred.user!.uid, "email": email, "heart_rate": 0});

        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Maaf tidak ada yang boleh kosong";
      }
    } on FirebaseException catch (error) {
      res = error.message!;
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
