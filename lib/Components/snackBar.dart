import 'package:flutter/material.dart';
import 'package:ringworm_detection/constraints.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kPrimaryColor,
      content: Text(text),
    ),
  );
}
