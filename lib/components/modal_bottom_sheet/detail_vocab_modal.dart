import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/custom_segment_button.dart';
import 'package:cookie_app/components/modal_bottom_sheet/image_option.dart';
import 'package:cookie_app/components/modal_bottom_sheet/topic_option.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

void showDetailVocabModalBottomSheet(
  BuildContext context,
  String topicId,
  String wordId,
  String word,
  String phonetic,
  String date,
  String definition,
  String image,
  String audio,
  String example,
  User user,
  TopicService topicService,
  String wordForm,
  Function(int) setNumOfVocabInTopic,
  int numOfVocabInTopic,
  Function(int) setNumOfVocab,
  int numOfVocab,
  // Assuming this is a dependency
) {
  void handleSelectionChange(WordForm selectedForm) {
    wordForm = selectedForm.toString().split('.').last;
  }

  TopicService topicService = TopicService();

  void showTopicOption(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder<QuerySnapshot>(
              stream: topicService.getTopicsByUserId(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final actions = snapshot.data!.docs.map((doc) {
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      addWordToTopic(() {
                        setNumOfVocabInTopic(numOfVocabInTopic + 1);
                        setNumOfVocab(numOfVocab - 1);
                      },
                          doc.id,
                          wordId,
                          Word(
                            word: word,
                            phonetic: phonetic,
                            definition: definition,
                            example: example,
                            image: image,
                            wordForm: wordForm,
                            date: date,
                            isFav: false,
                            audio: audio,
                            topicId: doc.id,
                            status: 0,
                            userId: user.uid,
                          ));
                      Navigator.of(context).pop();
                    },
                    child: Text(doc['topicName'],
                        style: const TextStyle(color: AppColors.icon_grey)),
                  );
                }).toList();
                return CupertinoActionSheet(
                  title: const Text('Thêm vào Topic'),
                  actions: actions,
                  actionScrollController: ScrollController(),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: AppColors.red)),
                  ),
                );
              });
        });
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(now); // Use the 'DateFormat' class to format the date
    return formattedDate;
  }

  Future<String> getDownloadUrlImage(String imagePath) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImageToUpload = referenceDirImage.child(fileName);
    String downloadUrl = '';

    try {
      // Assuming `imagePath` is the path to the image file you want to upload
      await referenceImageToUpload.putFile(File(imagePath));
      downloadUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      print('Error uploading image: $error');
      // Optionally, handle the error more gracefully or inform the user
    }

    return downloadUrl;
  }

  void showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    "https://cp.tdung.co/?url=${Uri.encodeComponent(image)}"),
                fit: BoxFit.cover,
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
  String audioUpdate = '';
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
                            InkWell(
                              onTap: () {
                                showTopicOption(context);
                              },
                              child: const Icon(
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
                                    audioUpdate =
                                        'https://translate.google.com/translate_tts?ie=UTF-8&q=%22"${word}"&tl=${word == "gay" ? "th" : "en"}&client=tw-ob';
                                    getDownloadUrlImage(image).then((url) {
                                      String imageUrl = url;
                                      if (topicId.isNotEmpty) {
                                        topicService.updateWordForTopic(
                                          topicId,
                                          wordId,
                                          Word(
                                            word: word,
                                            phonetic: phonetic,
                                            definition: definition,
                                            example: example,
                                            image: imageUrl.isNotEmpty
                                                ? imageUrl
                                                : image,
                                            wordForm: wordForm,
                                            date: getCurrentDate(),
                                            isFav: false,
                                            audio: audioUpdate,
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
                                            image: imageUrl.isNotEmpty
                                                ? imageUrl
                                                : image,
                                            wordForm: wordForm,
                                            date: getCurrentDate(),
                                            isFav: false,
                                            audio: audioUpdate,
                                            topicId: '',
                                            status: 0,
                                            userId: '',
                                          ),
                                        );
                                      }
                                    });
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
                            const InkWell(
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
                                        audioUpdate == ''
                                            ? "https://cp.tdung.co/?url=" +
                                                Uri.encodeComponent(audio)
                                            : "https://cp.tdung.co/?url=" +
                                                Uri.encodeComponent(
                                                    audioUpdate)));
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
                                      if (image.isNotEmpty) {
                                        showImageDialog(context, image);
                                      }
                                    },
                                    child: Container(
                                        width: Dimensions.width(context, 200),
                                        height: Dimensions.height(context, 250),
                                        decoration: BoxDecoration(
                                          color: image.isNotEmpty
                                              ? null
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: !image.contains("/data")
                                            ? Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://cp.tdung.co/?url=${Uri.encodeComponent(image)}",
                                                      placeholder:
                                                          (context, url) =>
                                                              SizedBox(
                                                        width:
                                                            20, // Adjust the width as per your requirement
                                                        height:
                                                            20, // Adjust the height as per your requirement
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: AppColors
                                                                .cookie,
                                                            strokeWidth:
                                                                2, // Adjust the strokeWidth as per your requirement
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                          url, error) {
                                                        print(error);
                                                        return Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        );
                                                      },
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Image.file(
                                                File(image),
                                                fit: BoxFit.contain,
                                              )),
                                  ),
                                  SizedBox(
                                      height: Dimensions.height(context, 12)),
                                  GestureDetector(
                                    onTap: edit == "Lưu"
                                        ? () {
                                            showImageOptionModalBottomSheet(
                                                context, (File? newImage) {
                                              setState(() {
                                                image = newImage!.path;
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
                                              const SizedBox(
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
