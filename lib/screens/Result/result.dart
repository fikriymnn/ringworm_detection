import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ringworm_detection/Components/snackBar.dart';
import 'package:ringworm_detection/storage.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Result extends StatefulWidget {
  Result({
    Key? key,
    required this.imagefile,
  }) : super(key: key);
  XFile imagefile;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List? result;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadModelData().then((output) {
//after loading models, rebuild the UI.
      setState(() {
        result = null;
      });
    });
  }

  loadModelData() async {
//tensorflow lite plugin loads models and labels.
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');

    detectDisease();
  }

  _openGoogleMaps() async {
    String url =
        "https://www.google.com/maps/search/?api=1&query=dermatologist+near+me";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka Google Maps';
    }
  }

  void detectDisease() async {
    try {
      result = await Tflite.runModelOnImage(
        path: widget.imagefile.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      addData();
    } catch (e) {
      // ignored, really.
    }
    setState(() {});
  }

  Future<void> addData() async {
    final _uuid = const Uuid().v4();
    try {
      if (result![0]['label'] != null) {
        imageUrl = await StorageMethods()
            .uploadImageToStorage("penyakit", widget.imagefile, true);

        await FirebaseFirestore.instance.collection('penyakit').doc(_uuid).set({
          'uid': _uuid,
          'img': imageUrl,
          'accuracy': result![0]['confidence'],
          'label': result![0]['label'],
          'createdAt': DateTime.now(),
        });
        showSnackBar(context, "upload berhasil");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Result Page"),
        ),
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0001,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.height * 1,
            child: Center(
              child: Image.file(File(widget.imagefile.path)),
              // Image.asset("assets/images/introimage.jpg"),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0001,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              result == null
                  ? const Text('Image Not Found')
                  : Text(
                      'Penyakit Kulit Terdeteksi : ${result![0]['label']} \n Accuracy : ${result![0]['confidence']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => _openGoogleMaps(),
              child: Text('Cari Dermatology Terdekat'),
            ),
          ),
        ]),
      ),
    );
  }
}
