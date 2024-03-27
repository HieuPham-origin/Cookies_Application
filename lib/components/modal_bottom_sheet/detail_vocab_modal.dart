import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_app/components/custom_segment_button.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:cookie_app/utils/demension.dart';

void showDetailVocabModalBottomSheet(
    BuildContext context,
    String word,
    String phonetic,
    String definition,
    File? image,
    String audio,
    String example,
    User user,
    TopicService topicService,
    String wordForm,
    void Function() onEditStateChanged
    // Assuming this is a dependency
    ) {
  void handleSelectionChange(WordForm selectedForm) {
    wordForm = selectedForm.toString().split('.').last;
  }

  final audioPlayer = AudioPlayer();
  String edit = "Sửa";

  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: false,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    backgroundColor: const Color(0xfff0f0f0),
    builder: (context) => SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        builder: (context, scrollController) => Column(
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
                        InkWell(
                          child: Icon(
                            Icons.bookmark_add,
                            color: AppColors.icon_grey,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Edit");
                            if (edit == "Sửa") {
                              edit = "Lưu";
                            } else {
                              edit = "Sửa";
                            }
                            onEditStateChanged();
                          },
                          child: Text(
                            edit,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.icon_grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: Dimensions.fontSize(context, 30),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.cookie,
                                  ),
                                ),
                              ),
                              Text(
                                phonetic,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: Dimensions.fontSize(context, 16),
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.grey_heavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              await audioPlayer.stop();
                              await audioPlayer.play(UrlSource(audio));
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
                        isDisabled: true,
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
                      Text(
                        definition,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: Dimensions.fontSize(context, 18),
                            color: AppColors.grey_heavy,
                            fontWeight: FontWeight.w500,
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
                      Text(
                        example,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: Dimensions.fontSize(context, 18),
                            color: AppColors.grey_heavy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height(context, 12),
                      ),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 250,
                          child:
                              image != null ? Image.file(image) : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
