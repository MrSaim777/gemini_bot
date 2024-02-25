import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_gemini/api_key.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/app_bar.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/loading_prompt.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/prompt_widget.dart';
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
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: geminiAppbar(loadingText),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: [
                !loadingText
                    ? const SizedBox.shrink()
                    : const LoadingResponseWidget(),
                ...listOfPromts
              ],
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
                        hintText: 'Type your prompt here...',
                        hintStyle:
                            TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.mic,
                        color: Utils.kPrimaryColor,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  geminiChat({required String prompt}) async {
    try {
      controller.animateTo(100,
          duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
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
    listOfPromts.add(PromptWidget(msgText: text, msgSender: text, user: false));
    setState(() {});
  }

  addPromptToList() async {
    if (promptController.text.isNotEmpty) {
      listOfPromts.add(PromptWidget(
          msgText: promptController.text, msgSender: '', user: true));
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
