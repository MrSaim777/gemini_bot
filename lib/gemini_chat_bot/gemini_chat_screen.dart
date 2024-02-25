import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_gemini/api_key.dart';
import 'package:google_gemini/utils.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final promptController = TextEditingController();
  String text = '';
  bool loadingText = false;
  List<PromptWidget> listOfPromts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: listOfPromts,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                    child: TextField(
                      onChanged: (value) {},
                      onSubmitted: (value) {},
                      controller: promptController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                    onTap: loadingText
                        ? () => Utils.snackBar(context, 'Please wait')
                        : addPromptToList,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.send,
                        color: Utils.kPrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  geminiChat({required String prompt}) async {
    try {
      loadingTextState(true);
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      loadingTextState(false);
      textValue(response.text);
    } catch (e, t) {
      loadingTextState(false);
      log(e.toString(), name: 'Error');
      log(t.toString(), name: 'Trace');
    }
  }

  loadingTextState(bool value) {
    setState(() {
      loadingText = value;
    });
  }

  textValue(String? text) {
    text = text ?? 'something went wrong';
    listOfPromts.add(PromptWidget(
        msgText: text, msgSender: text, user: false, loading: loadingText));
    setState(() {});
  }

  addPromptToList() async {
    if (promptController.text.isNotEmpty) {
      listOfPromts.add(PromptWidget(
          msgText: promptController.text,
          msgSender: '',
          user: true,
          loading: loadingText));
      geminiChat(prompt: promptController.text);
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          promptController.text = '';
          setState(() {});
        },
      );
    } else {
      Utils.snackBar(context, 'Enter Prompt');
    }
  }
}

class PromptWidget extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  final bool loading;
  const PromptWidget(
      {super.key,
      required this.msgText,
      required this.msgSender,
      required this.user,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return loading
        ? Padding(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            ))
        : Padding(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
