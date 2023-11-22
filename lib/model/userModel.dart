import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid, noHp, alamat, riwayatPenyakit, email, nama, img;
  final DateTime tanggalLahir;
  final Timestamp createdAt;

  const UserModel(
      {required this.createdAt,
      required this.uid,
      required this.nama,
      required this.email,
      required this.tanggalLahir,
      required this.noHp,
      required this.alamat,
      required this.riwayatPenyakit,
      required this.img});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      createdAt: snapshot["createdAt"],
      uid: snapshot["uid"],
      nama: snapshot['nama'],
      email: snapshot["email"],
      alamat: snapshot["alamat"],
      tanggalLahir: snapshot["tglLahir"],
      img: snapshot["img"],
      noHp: snapshot["noHp"],
      riwayatPenyakit: snapshot["riwayatPenyakit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "nama": nama,
        "alamat": alamat,
        "img": img,
        "riwayatPenyakit": riwayatPenyakit,
        "noHp": noHp,
        "tglLahir": tanggalLahir,
        "createdAt": Timestamp.now()
      };
}
