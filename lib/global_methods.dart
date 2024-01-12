import 'package:flutter/material.dart';

import 'widget/widget_text.dart';

class GlobalMethods {
  static Future<void> warningDialog(
      {required String title,
      required String subtitle,
      required Function fct,
      required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              subtitle,
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'Cancel',
                  textSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.red,
                  text: 'OK',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog(
      {required String subtitle, required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Row(
            //   children: [
            //     Image.asset(
            //       'assets/images/logo_ask_no_name.png',
            //       height: 20,
            //       width: 20,
            //       fit: BoxFit.fill,
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //     Text('Error'),
            //   ],
            // ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: 'OK',
                  textSize: 18,
                ),
              ),
            ],
          );
        });
  }
}
