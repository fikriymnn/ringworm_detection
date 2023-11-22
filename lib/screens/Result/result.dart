import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:url_launcher/url_launcher.dart';

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
  @override
  void initState() {
    super.initState();
//     loadModelData().then((output) {
// //after loading models, rebuild the UI.
//       setState(() {
//         result = null;
//       });
//     });
  }

//   loadModelData() async {
// //tensorflow lite plugin loads models and labels.
//     await Tflite.loadModel(
//         model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');

//     detectDisease();
//   }

  _openGoogleMaps() async {
    String url =
        "https://www.google.com/maps/search/?api=1&query=dermatologist+near+me";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka Google Maps';
    }
  }

  // void detectDisease() async {
  //   try {
  //     result = await Tflite.runModelOnImage(
  //       path: widget.imagefile.path,
  //       numResults: 2,
  //       threshold: 0.6,
  //       imageMean: 127.5,
  //       imageStd: 127.5,
  //     );
  //   } catch (e) {
  //     // ignored, really.
  //   }
  //   setState(() {});
  // }

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
