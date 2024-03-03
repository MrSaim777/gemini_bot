import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_gemini/api_key.dart';
import 'package:google_gemini/database/db.dart';
import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/app_bar.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/loading_prompt.dart';
import 'package:google_gemini/gemini_chat_bot/widgets/prompt_widget.dart';
import 'package:google_gemini/utils.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  // ScrollController controller = ScrollController();
  PromptDB promptDB = PromptDB();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      print('listening');
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      print('stop listening');
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      promptController.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: geminiAppbar(loadingText, context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: listOfPromts.isEmpty
                ? const Center(
                    child: Text('Write/Speak something for response',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Utils.kPrimaryColor)),
                  )
                : ListView(
                    // controller: controller,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
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
                    InkWell(
                      onTap: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.mic,
                          color: _speechToText.isNotListening
                              ? Utils.kPrimaryColor
                              : Utils.kMicBtnColor,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  geminiChat({required String prompt}) async {
    try {
      // controller.animateTo(100,
      //     duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
      loadingTextState(true);

      try {
        final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        loadingTextState(false);
        await promptDB.putPromptToDB(Prompt(
            id: DateTime.now().millisecondsSinceEpoch,
            dateTime: DateTime.now(),
            prompt: prompt,
            result: response.text ?? 'No response'));
        textValue(response.text);
      } catch (e, t) {
        await promptDB.putPromptToDB(Prompt(
            id: DateTime.now().millisecondsSinceEpoch,
            dateTime: DateTime.now(),
            prompt: prompt,
            result: e.toString()));
        textValue(e.toString());
        loadingTextState(false);
        log(e.toString(), name: 'Hive error');
        log(t.toString(), name: 'trace');
      }
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
      listOfPromts.clear();
      setState(() {});
      listOfPromts.add(PromptWidget(
          msgText: promptController.text, msgSender: '', user: true));
      geminiChat(prompt: promptController.text);
      await Future.delayed(
        const Duration(milliseconds: 500),
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
