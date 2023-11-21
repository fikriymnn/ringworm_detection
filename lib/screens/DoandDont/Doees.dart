//done with do's and don't not finalized the dimensions
import 'package:flutter/material.dart';

import '../../navigationDrawer/navigationDrawer.dart';

class Dos extends StatelessWidget {
  const Dos({Key? key}) : super(key: key);

  static const String routeName = '/dodontpage';

  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Do's and Don'ts"),
        ),
        body: SingleChildScrollView(
          child: Material(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // const Text(
                    //   "Do's and Don't",
                    //   style:
                    //       TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    const Box(
                      points: Text(
                        "1.Kebersihan pribadi adalah keharusan\n2.Jaga diri Anda tetap bersih dan kering.\n3.Setelah Mandi Keringkan seluruh bagian tubuh.\n4.Gunakan handuk untuk menjaga area kering yang berkeringat\n5.Setelah gym, sesi olahraga, mandi dan bersihkan dirimu secara menyeluruh.\n",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      color: Color(0xff8CE07E),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    const Box(
                      points: Text(
                        "1.Hindari penggunaan minyak pada area yang terkena minyak.\n2.Jangan gatal atau menggosok area yang terkena minyak.\n3.Hindari pakaian berbahan nilon dan sintetis sebisa mungkin.\n4.Hindari kontak langsung dengan orang.\n5.Hindari tempat yang terlalu banyak minyak. keramaian atau pertemuan umum seperti di kolam renang\n",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      color: Color(0xffF47A7A),
                    ),
                  ]),
            ),
          ),
        ),
        drawer: const NavigatorDrawer(),
      ),
    );
  }
}

class Box extends StatelessWidget {
  //box class to create a container with some text on it.
  const Box({
    Key? key,
    required this.points,
    required this.color,
  }) : super(key: key);

  final Text points;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      // color: col,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(37)),
        color: color,
      ),
      child: Container(
          padding: const EdgeInsets.all(12), child: Center(child: points)),
    );
  }
}
