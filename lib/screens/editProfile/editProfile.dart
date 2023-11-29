import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Components/snackBar.dart';
import '../../constraints.dart';
import '../../global_methods.dart';
import '../../navigationDrawer/navigationDrawer.dart';
import '../../storage.dart';
import '../../widget/defaultTextField.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const String routeeName = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  XFile? _image;
  DateTime _selectedDate = DateTime.now();
  String? _photoUrl;
  User? user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _alamatTextController = TextEditingController();
  final _noHpTextController = TextEditingController();
  final _penyakitTextController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _alamatFocusNode = FocusNode();
  final _noHpFocusNode = FocusNode();
  final _penyakitFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _userNameFocusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _alamatTextController.dispose();
    _noHpTextController.dispose();
    _penyakitTextController.dispose();

    _fullNameFocusNode.dispose();
    _alamatFocusNode.dispose();
    _noHpFocusNode.dispose();
    _penyakitFocusNode.dispose();
    _userNameFocusNode.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('akun')
          .doc(user!.uid)
          .get();
      if (userDoc == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        _noHpTextController.text = userDoc.get('noHp');
        _alamatTextController.text = userDoc.get('alamat');
        _fullNameController.text = userDoc.get('nama');
        _photoUrl = userDoc.get('img');
        _penyakitTextController.text = userDoc.get('riwayatPenyakit');
        _selectedDate = userDoc.get('tglLahir').toDate();
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Profile",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500))),
      ),
      drawer: const NavigatorDrawer(),
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(File(_image!.path)),
                            backgroundColor: Colors.red,
                          )
                        : _photoUrl != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(_photoUrl!),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://i.stack.imgur.com/l60Hf.png'),
                              ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () async {
                          try {
                            final XFile? file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (file != null) {
                              setState(() {
                                _image = file;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const ShapeDecoration(
                              color: kPrimaryColor, shape: CircleBorder()),
                          child: const Icon(
                            Icons.camera,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                DefaultTextFild(
                  compliteFocusNode: _noHpFocusNode,
                  controller: _fullNameController,
                  focusNode: _fullNameFocusNode,
                  hintText: "Nama",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid value";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextFild(
                  compliteFocusNode: _alamatFocusNode,
                  controller: _noHpTextController,
                  focusNode: _noHpFocusNode,
                  hintText: "No Hp",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid value";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextFild(
                  compliteFocusNode: _penyakitFocusNode,
                  controller: _alamatTextController,
                  focusNode: _alamatFocusNode,
                  hintText: "Alamat",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid value";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextFild(
                  compliteFocusNode: _penyakitFocusNode,
                  controller: _penyakitTextController,
                  focusNode: _penyakitFocusNode,
                  hintText: "Riwayat Penyakit",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          DateTime? pickDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(3000));

                          if (pickDate != null) {
                            setState(() {
                              _selectedDate = pickDate;
                            });
                          }
                        },
                        child: Container(
                            height: 35,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: kPrimaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "Pilih Tanggal",
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${DateFormat("dd/MMMM/yyyy").format(_selectedDate)}",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    String? photoUrl;

                    if (_image == null) {
                      photoUrl = "";
                    } else {
                      photoUrl = await StorageMethods()
                          .uploadImageToStorage('profilePics', _image!, false);
                    }
                    try {
                      await FirebaseFirestore.instance
                          .collection('akun')
                          .doc(user!.uid)
                          .update({
                        'nama': _fullNameController.text,
                        'img': photoUrl,
                        'riwayatPenyakit': _penyakitTextController.text,
                        'noHp': _noHpTextController.text,
                        'tglLahir': _selectedDate,
                        'alamat': _alamatTextController.text
                      });
                      GlobalMethods.errorDialog(
                          subtitle: "Berhasil di Edit", context: context);
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          subtitle: err.toString(), context: context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Edit",
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
