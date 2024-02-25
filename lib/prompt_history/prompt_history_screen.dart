import 'package:flutter/material.dart';
import 'package:google_gemini/database/db.dart';
import 'package:google_gemini/database/prompt_db_model.dart';
import 'package:google_gemini/prompt_history/app_bar.dart';
import 'package:google_gemini/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class PromptHistoryScreen extends StatelessWidget {
  const PromptHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: geminiHistoryAppbar(context),
        body: ValueListenableBuilder<Box<Prompt>>(
          valueListenable: PromptDB.box().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<Prompt>();
            return ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final date =
                      DateFormat.yMMMMEEEEd().format(data[index].dateTime);
                  final time = DateFormat.jms().format(data[index].dateTime);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Material(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: Utils.kPrimaryColor,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  data[index].prompt,
                                  style: const TextStyle(
                                    color: Utils.kWhiteColor,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$date $time',
                            style: const TextStyle(
                              color: Utils.kPrimaryColor,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  data[index].result,
                                  style: const TextStyle(
                                    color: Utils.kWhiteColor,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            )),
                        const Divider()
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
