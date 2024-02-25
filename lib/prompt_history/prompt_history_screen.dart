import 'package:flutter/material.dart';
import 'package:google_gemini/database/db.dart';
import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PromptHistoryScreen extends StatelessWidget {
  const PromptHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<Box<Prompt>>(
      valueListenable: PromptDB.box().listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<Prompt>();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
              itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [Text(data[index].prompt)],
                  ),
                );
              }),
        );
      },
    ));
  }
}
