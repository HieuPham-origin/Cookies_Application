import 'dart:convert';
import 'dart:io';

import 'package:cookie_app/components/custom_segment_button.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_app/components/modal_bottom_sheet/image_option.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy')
      .format(now); // Use the 'DateFormat' class to format the date
  return formattedDate;
}

Future<String> getPhoneticValues(String word) async {
  final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    List<dynamic> jsonResponse = json.decode(response.body);

    for (var item in jsonResponse) {
      // Assuming each item might have a 'phonetics' list.
      if (item.containsKey('phonetics') && item['phonetics'].isNotEmpty) {
        for (var phonetic in item['phonetics']) {
          // Check if 'text' exists in phonetic
          if (phonetic.containsKey('text')) {
            // Print the phonetic text
            return phonetic['text'];
          }
        }
      }
    }
    return "";
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return "";
  }
}

Future<String> getExample(String word) async {
  final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    List<dynamic> jsonResponse = json.decode(response.body);

    for (var item in jsonResponse) {
      // Assuming each item might have a 'meanings' list.
      if (item.containsKey('meanings') && item['meanings'].isNotEmpty) {
        for (var meaning in item['meanings']) {
          // Check if 'definitions' exists in meaning
          if (meaning.containsKey('definitions') &&
              meaning['definitions'].isNotEmpty) {
            for (var definition in meaning['definitions']) {
              // Check if 'example' exists in definition
              if (definition.containsKey('example')) {
                // Print the example
                return definition['example'];
              }
            }
          }
        }
      }
    }
    return "There is no example for this word";
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return "There is no example for this word";
  }
}

void showAddVocabModalBottomSheet(
    BuildContext context,
    TextEditingController wordController,
    TextEditingController definitionController,
    User user,
    String wordHintText,
    File? image,
    String wordForm,
    Function(int) setNumOfWord,
    int numOfWord) {
  wordController.clear();
  definitionController.clear();
  image = null;
  wordHintText = "";
  bool isLoading = false;

  void handleSelectionChange(WordForm selectedForm) {
    wordForm = selectedForm.toString().split('.').last;
  }

  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      backgroundColor: const Color(0xfffefffe),
      builder: (context) => StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return SafeArea(
              child: GestureDetector(
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.95,
                  builder: (context, scrollController) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.header_background,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: !isLoading
                                  ? () async {
                                      // Remove focus from any text fields to hide the keyboard
                                      FocusScope.of(context).unfocus();

                                      // Wait for a short duration to ensure the keyboard dismiss animation can complete
                                      await Future.delayed(
                                          const Duration(milliseconds: 200));

                                      // Then, navigate back to the previous screen
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                              child: const Text(
                                "Hủy",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.cookie,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Text(
                              "Tạo từ vựng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.cookie,
                              ),
                            ),
                            InkWell(
                                onTap: () async {
                                  if (wordController.text.isEmpty) {
                                    setState(() {
                                      wordHintText =
                                          "Từ vựng không được để trống";
                                    });

                                    return;
                                  }
                                  // setModalState(() {
                                  //   isLoading = true;
                                  // });

                                  setState(() {
                                    isLoading = true;
                                  });
                                  Word word = Word(
                                    word: wordController.text,
                                    definition: definitionController.text,
                                    phonetic: await getPhoneticValues(
                                        wordController.text),
                                    date: getCurrentDate(),
                                    image: image != null ? image!.path : "",
                                    wordForm:
                                        wordForm == "" ? "verb" : wordForm,
                                    example:
                                        await getExample(wordController.text),
                                    audio:
                                        'https://translate.google.com/translate_tts?ie=UTF-8&q=%22"${wordController.text}"&tl=${wordController.text == "gay" ? "th" : "en"}&client=tw-ob',
                                    isFav: false,
                                    topicId: "",
                                    status: 0,
                                    userId: user.uid,
                                  );

                                  try {
                                    await WordService().addWord(word);
                                    FocusScope.of(context).unfocus();
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    setNumOfWord(numOfWord + 1);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    print('Failed to add word: $e');
                                    // Optionally, show an error toast or dialog
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  width: Dimensions.width(context,
                                      40), // Adjust width according to your needs
                                  height:
                                      24, // Adjust height according to your needs
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Visibility(
                                        visible: isLoading,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.cookie),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isLoading,
                                        child: Text(
                                          "Tiếp",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.cookie,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: wordController,
                                  autofocus: true,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: wordHintText,
                                    hintStyle: const TextStyle(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.cookie),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "TỪ VỰNG",
                                    style: TextStyle(
                                      color: AppColors.grey_light,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  textAlign: TextAlign.start,
                                  controller: definitionController,
                                  style: GoogleFonts.inter(),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                    suffixIconConstraints: const BoxConstraints(
                                        maxHeight: 24, maxWidth: 24),
                                    suffixIcon: IconButton(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      onPressed: () {
                                        showImageOptionModalBottomSheet(
                                            context, image, (File? newImage) {
                                          setState(() {
                                            image = newImage;
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.cookie),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "ĐỊNH NGHĨA",
                                    style: TextStyle(
                                      color: AppColors.grey_light,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomSegmentButton(
                              onSelectionChanged: handleSelectionChange,
                              wordForm: wordForm,
                              isDisabled: isLoading,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: Dimensions.width(context, 200),
                              height: Dimensions.height(context, 250),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(image ?? File("")),
                                  fit: BoxFit.contain,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }));
}
