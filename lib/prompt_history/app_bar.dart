import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/utils.dart';

AppBar geminiHistoryAppbar(BuildContext context) {
  return AppBar(
      iconTheme: const IconThemeData(color: Utils.kPrimaryColor),
      elevation: 0,
      backgroundColor: Colors.white10,
      centerTitle: true,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back)),
      title: const Text(
        'History',
        style: TextStyle(
            fontFamily: 'Poppins',
            color: Utils.kPrimaryColor,
            fontWeight: FontWeight.bold),
      ));
}
