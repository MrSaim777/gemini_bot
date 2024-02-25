 import 'package:flutter/material.dart';
import 'package:google_gemini/utils.dart';

AppBar geminiAppbar(bool loadingText) {
    return AppBar(
      iconTheme: const IconThemeData(color: Utils.kPrimaryColor),
      elevation: 0,
      bottom: !loadingText
          ? null
          : PreferredSize(
              preferredSize: const Size(25, 10),
              child: Container(
                constraints: const BoxConstraints.expand(height: 1),
                child: const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Utils.kPrimaryColor,
                ),
              ),
            ),
      backgroundColor: Colors.white10,
      centerTitle: true,
      title: const Text(
        'Gemini Bot',
        style: TextStyle(
            fontFamily: 'Poppins',
            color: Utils.kPrimaryColor,
            fontWeight: FontWeight.bold),
      ),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.history))],
    );
  }