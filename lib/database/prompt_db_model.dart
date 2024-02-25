import 'package:hive/hive.dart';

part 'prompt_db_model.g.dart';

@HiveType(typeId: 0)
class Prompt {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String prompt;

  @HiveField(3)
  final String result;

  Prompt({
    required this.id,
    required this.dateTime,
    required this.prompt,
    required this.result,
  });
}
