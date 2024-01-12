import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ringworm_detection/auth.dart';
import 'package:ringworm_detection/storage.dart';
import '../../Components/snackBar.dart';
import '../../authDocter.dart';
import '../../constraints.dart';
import '../../routes/pageRoute.dart';
import 'package:intl/intl.dart';

import '../../widget/defaultTextField.dart';

class RegistrasiScreensDoctor extends StatefulWidget {
  const RegistrasiScreensDoctor({super.key});
  static const String routeName = '/registrasiDoctor';

  @override
  State<RegistrasiScreensDoctor> createState() =>
      _RegistrasiScreensDoctorState();
}

class _RegistrasiScreensDoctorState extends State<RegistrasiScreensDoctor> {
  XFile? _image;

  String? fileName = "";

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _alamatTextController = TextEditingController();
  final _alamatLinkTextController = TextEditingController();
  final _noHpTextController = TextEditingController();
  final _penyakitTextController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _alamatFocusNode = FocusNode();
  final _alamatLinkFocusNode = FocusNode();
  final _noHpFocusNode = FocusNode();
  final _penyakitFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();

  final _userNameFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _alamatTextController.dispose();
    _alamatLinkTextController.dispose();
    _noHpTextController.dispose();
    _penyakitTextController.dispose();

    _emailTextController.dispose();
    _userNameTextController.dispose();
    _passTextController.dispose();

    _fullNameFocusNode.dispose();
    _alamatFocusNode.dispose();
    _alamatLinkFocusNode.dispose();
    _noHpFocusNode.dispose();
    _penyakitFocusNode.dispose();
    _userNameFocusNode.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  // final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void signUpUser() async {
    // set loading to true
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String? sertifikatFile;

      if (_image == null) {
        sertifikatFile = "";
      } else {
        sertifikatFile = await StorageMethods()
            .uploadImageToStorage('sertifikat', _image!, false);
      }

      // signup user using our authmethodds
      String res = await AuthMethodsDoctor().signUpUser(
          createdAt: Timestamp.now(),
          password: _passTextController.text,
          email: _emailTextController.text,
          alamat: _alamatTextController.text,
          nama: _fullNameController.text,
          noHp: _noHpTextController.text,
          sertifikat: sertifikatFile,
          alamatLink: _alamatLinkTextController.text);

      // if string returned is sucess, user has been created
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(
            context, PageRoutes.verifikasiEmail, (route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
        showSnackBar(context, res);
      }
    }
  }

  // selectImage() async {
  //   Uint8List im = await pickImage(ImageSource.gallery);
  //   // set state because we need to display the image we selected on the circle avatar
  //   setState(() {
  //     _image = im;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, PageRoutes.login, (route) => false);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text("Registrasi Doctor",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500))),
      ),
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
                DefaultTextFild(
                  compliteFocusNode: _passFocusNode,
                  controller: _emailTextController,
                  focusNode: _emailFocusNode,
                  hintText: "Email",
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Please enter a valid Email adress";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _passFocusNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_fullNameFocusNode),
                  obscureText: _obscureText,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passTextController,
                  validator: (value) {
                    if (value!.isEmpty && value.length <= 6) {
                      return "Please enter a valid password";
                    } else {
                      return null;
                    }
                  },
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: kPrimaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500))),
                ),
                SizedBox(
                  height: 10,
                ),
                DefaultTextFild(
                  compliteFocusNode: _noHpFocusNode,
                  controller: _fullNameController,
                  focusNode: _fullNameFocusNode,
                  hintText: "Nama",
                  label: "Nama",
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
                  label: "No Hp",
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
                  hintText: "Alamat Rumah Sakit",
                  label: "Alamat Rumah Sakit",
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
                  compliteFocusNode: _alamatLinkFocusNode,
                  controller: _alamatLinkTextController,
                  focusNode: _alamatLinkFocusNode,
                  hintText: "Link Alamat Rumah Sakit",
                  label: "Link Alamat Rumah Sakit",
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          try {
                            final XFile? file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (file != null) {
                              setState(() {
                                _image = file;
                                fileName = file.name;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                            height: 50,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: kPrimaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "Masukan Sertifikat",
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
                        fileName!,
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
                  onTap: () {
                    signUpUser();
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
                                "Registrasi",
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Sudah punya akun?",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, PageRoutes.login);
                          },
                          child: Text("Login di sini",
                              style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500))))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
