import 'package:flutter/material.dart';
import 'package:google_gemini/database/db.dart';
import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:google_gemini/gemini_chat_bot/gemini_chat_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initHive();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Google Gemini',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true),
    home: const GeminiChatScreen(),
  ));
}

initHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final path = appDocumentDirectory.path;
  Hive.init(path);
  Hive.registerAdapter(PromptAdapter());
  await Hive.openBox<Prompt>(PromptDB().boxName);
}
