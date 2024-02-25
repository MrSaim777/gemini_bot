import 'package:flutter/material.dart';
import 'package:google_gemini/gemini_chat_bot/gemini_chat_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Google Gemini',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true),
    home: const GeminiChatScreen(),
  ));
}
