import 'package:flutter/material.dart';

class Utils {
  static const Color kPrimaryColor = Colors.black;
  static const Color kSecondaryColor = Colors.grey;
  static const Color kWhiteColor = Colors.white;


  static snackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 500),
        backgroundColor: kPrimaryColor));
  }
}
