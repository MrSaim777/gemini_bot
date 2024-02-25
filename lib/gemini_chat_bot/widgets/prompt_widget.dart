import 'package:flutter/material.dart';
import 'package:google_gemini/utils.dart';

class PromptWidget extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  const PromptWidget(
      {super.key,
      required this.msgText,
      required this.msgSender,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(10),
            topLeft: const Radius.circular(10),
            bottomRight:
                user ? const Radius.circular(0) : const Radius.circular(10),
            topRight: const Radius.circular(10),
          ),
          color: user ? Utils.kPrimaryColor : Utils.kSecondaryColor,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              msgText,
              style: const TextStyle(
                color: Utils.kWhiteColor,
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
          ),
        ));
  }
}
