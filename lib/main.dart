import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_gemini/database/db.dart';
import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:google_gemini/features/gemini_prompt/screens/gemini_chat_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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

Future<void> initHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final path = appDocumentDirectory.path;
  Hive.init(path);
  Hive.registerAdapter(PromptAdapter());
  await Hive.openBox<Prompt>(PromptDB().boxName);
}
