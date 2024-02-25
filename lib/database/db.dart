import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:hive/hive.dart';

class PromptDB {
  final boxName = 'prompts';
  static Box<Prompt> box() => Hive.box<Prompt>('prompts');
 
  Future<void> closeBox() async {
    await box().close();
  }

  Future<void> putPromptToDB(Prompt prompt) async {
    await box().put(prompt.id, prompt);
  }

  Future<Prompt?> getPromptFromDB(int id) async {
    return box().get(id);
  }

  Future<List<Prompt>> getAllPrompts() async {
    return box().values.toList();
  }

  Future<void> deletePrompt(int id) async {
    await box().delete(id);
  }

  Future<void> clearDB() async {
    await box().clear();
  }
}
