import 'package:flutter/material.dart';

import '../../navigationDrawer/navigationDrawer.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  static const String routeName = '/aboutcreators';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("About Me"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, left: 0),
            child: Text(
              "Developed by:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              " Billy",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      )),
      drawer: const NavigatorDrawer(),
    ));
  }
}
