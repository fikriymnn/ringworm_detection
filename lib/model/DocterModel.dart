import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String uid, noHp, alamat, email, nama, img, role, alamatLink;
  final Timestamp createdAt;

  const DoctorModel(
      {required this.createdAt,
      required this.uid,
      required this.nama,
      required this.email,
      required this.noHp,
      required this.alamat,
      required this.alamatLink,
      required this.role,
      required this.img});

  static DoctorModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return DoctorModel(
      createdAt: snapshot["createdAt"],
      uid: snapshot["uid"],
      nama: snapshot['nama'],
      email: snapshot["email"],
      alamat: snapshot["alamat"],
      alamatLink: snapshot['alamatLink'],
      img: snapshot["img"],
      noHp: snapshot["noHp"],
      role: snapshot["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "nama": nama,
        "alamat": alamat,
        "alamatLink": alamatLink,
        "img": img,
        "noHp": noHp,
        "role": role,
        "createdAt": Timestamp.now()
      };
}
