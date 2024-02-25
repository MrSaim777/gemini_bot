
import 'package:flutter/material.dart';
import 'package:google_gemini/utils.dart';

class LoadingResponseWidget extends StatelessWidget {
  const LoadingResponseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Material(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Utils.kSecondaryColor,
          elevation: 5,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Generating response',
                    style: TextStyle(
                      color: Utils.kPrimaryColor,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Utils.kPrimaryColor),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Utils.kPrimaryColor),
                  ),
                  Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Utils.kPrimaryColor),
                  )
                ],
              )),
        ));
  }
}
