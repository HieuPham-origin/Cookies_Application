import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_app/components/custom_segment_button.dart';
import 'package:cookie_app/components/modal_bottom_sheet/image_option.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:cookie_app/components/loading_skeleton.dart';

void showDetailVocabModalBottomSheet(
  BuildContext context,
  String topicId,
  String wordId,
  String word,
  String phonetic,
  String definition,
  File? image,
  String audio,
  String example,
  User user,
  TopicService topicService,
  String wordForm,
  // Assuming this is a dependency
) {
  void handleSelectionChange(WordForm selectedForm) {
    wordForm = selectedForm.toString().split('.').last;
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(now); // Use the 'DateFormat' class to format the date
    return formattedDate;
  }

  void showImageDialog(BuildContext context, File? image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Getting the screen size
        Size screenSize = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors
              .transparent, // Ensures no background color for the dialog itself
          insetPadding: EdgeInsets.all(10), // Adjust the padding as needed
          child: Container(
            // Set width and height as a proportion of the screen size
            width: screenSize.width * 0.9, // 90% of screen width
            height: screenSize.height * 0.7, // 70% of screen height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(15), // Adjust borderRadius as needed
            ),
            child: ClipRRect(
              // Clip it with rounded corners
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                image!,
                fit: BoxFit.cover, // Use BoxFit.cover to fill the container
              ),
            ),
          ),
        );
      },
    );
  }

  final audioPlayer = AudioPlayer();
  String edit = "Sửa";
  TextEditingController wordController = TextEditingController(text: word);
  TextEditingController phoneticController = TextEditingController(
      text: phonetic == "" ? "/transcription/" : phonetic);
  TextEditingController definitionController =
      TextEditingController(text: definition);
  TextEditingController exampleController =
      TextEditingController(text: example);
  String audio_update = '';
  FocusNode focusNode = FocusNode();
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    backgroundColor: AppColors.background,
    builder: (context) => SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        builder: (context, scrollController) => StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfffcfafb),
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
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Hủy",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.icon_grey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const InkWell(
                              child: Icon(
                                Icons.bookmark_add,
                                color: AppColors.icon_grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  edit = edit == "Sửa" ? "Lưu" : "Sửa";
                                  if (edit == "Lưu") {
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      focusNode.requestFocus();
                                    });
                                  } else {
                                    String word = wordController.text;
                                    String phonetic = phoneticController.text;
                                    String definition =
                                        definitionController.text;
                                    String example = exampleController.text;
                                    audio_update =
                                        'https://translate.google.com/translate_tts?ie=UTF-8&q=%22"${word}"&tl=${word == "gay" ? "th" : "en"}&client=tw-ob';

                                    if (topicId.isNotEmpty) {
                                      topicService.updateWordForTopic(
                                        topicId,
                                        wordId,
                                        Word(
                                          word: word,
                                          phonetic: phonetic,
                                          definition: definition,
                                          example: example,
                                          image: image!.path,
                                          wordForm: wordForm,
                                          date: getCurrentDate(),
                                          isFav: false,
                                          audio: audio_update,
                                          topicId: '',
                                          status: 0,
                                          userId: '',
                                        ),
                                      );
                                    } else {
                                      WordService wordService = WordService();
                                      wordService.updateWord(
                                        wordId,
                                        Word(
                                          word: word,
                                          phonetic: phonetic,
                                          definition: definition,
                                          example: example,
                                          image: image!.path,
                                          wordForm: wordForm,
                                          date: getCurrentDate(),
                                          isFav: false,
                                          audio: audio_update,
                                          topicId: '',
                                          status: 0,
                                          userId: '',
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  edit,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: edit == "Lưu"
                                        ? AppColors.cookie
                                        : AppColors.icon_grey,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                CupertinoIcons.share_up,
                                color: AppColors.icon_grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Dimensions.width(context,
                                          250), // Adjust width as needed
                                      // Adjust height as needed
                                      child: TextField(
                                        enabled: edit == "Lưu" ? true : false,
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        controller: wordController,
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: Dimensions.fontSize(
                                                context, 30),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.cookie,
                                          ),
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                        onChanged: (newValue) {
                                          word = newValue;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.width(context, 250),
                                      child: TextField(
                                        enabled: edit == "Lưu" ? true : false,
                                        maxLength: 25,
                                        controller: phoneticController,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                            fontSize: Dimensions.fontSize(
                                                context, 16),
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.grey_heavy,
                                          ),
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          border: InputBorder.none,
                                          counterText: "",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await audioPlayer.stop();
                                    await audioPlayer.play(UrlSource(
                                        audio_update == ''
                                            ? audio
                                            : audio_update));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        4), // Adjust padding as needed

                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(
                                          0.6), // Adjust color and opacity as needed
                                    ),
                                    child: const Icon(
                                      Icons.volume_up,
                                      size: 52, // Adjust icon size as needed
                                      color: AppColors
                                          .creamy, // Adjust icon color as needed
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomSegmentButton(
                              onSelectionChanged: handleSelectionChange,
                              wordForm: wordForm,
                              isDisabled: edit == "Lưu" ? false : true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Định nghĩa",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 14),
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.grey_light,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                enabled: edit == "Lưu" ? true : false,
                                maxLines: null,
                                controller: definitionController,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: Dimensions.fontSize(context, 18),
                                    color: AppColors.grey_heavy,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                  border: InputBorder.none,
                                  counterText: "",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height(context, 12),
                            ),
                            Text(
                              "Ví dụ",
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 14),
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.grey_light,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                enabled: edit == "Lưu" ? true : false,
                                maxLines: null,
                                controller: exampleController,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: Dimensions.fontSize(context, 18),
                                    color: AppColors.grey_heavy,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                  border: InputBorder.none,
                                  counterText: "",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height(context, 22),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (image!.path.isNotEmpty) {
                                        showImageDialog(context, image);
                                      }
                                    },
                                    child: Container(
                                      width: Dimensions.width(context, 200),
                                      height: Dimensions.height(context, 250),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.contain,
                                        ),
                                        color: image!.path.isNotEmpty
                                            ? null
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: Dimensions.height(context, 12)),
                                  GestureDetector(
                                    onTap: edit == "Lưu"
                                        ? () {
                                            showImageOptionModalBottomSheet(
                                                context, image,
                                                (File? newImage) {
                                              setState(() {
                                                image = newImage;
                                              });
                                            });
                                          }
                                        : null,
                                    child: edit == "Lưu"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .camera_fill, // Replace Icons.image with the desired icon
                                                color: AppColors
                                                    .grey_heavy, // Set the color of the icon
                                                size: Dimensions.fontSize(
                                                    context,
                                                    18), // Set the size of the icon
                                              ),
                                              SizedBox(
                                                  width:
                                                      5), // Add some space between the icon and text
                                              Text(
                                                "Chọn ảnh",
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    fontSize:
                                                        Dimensions.fontSize(
                                                            context, 18),
                                                    color: AppColors.grey_heavy,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height(context, 42),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    ),
  );
}
