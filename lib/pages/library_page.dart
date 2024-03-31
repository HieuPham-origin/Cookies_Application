// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_topic_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_vocab_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/topic_option.dart';
import 'package:cookie_app/components/title_widget.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/pages/detail_topic_page.dart';
import 'package:cookie_app/pages/practice_pages/quiz_screen.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toasty_box/toasty_box.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  File? _image;
  final topicController = TextEditingController();
  final topicService = TopicService();
  final user = FirebaseAuth.instance.currentUser!;
  bool _btnActive = false;

  final wordController = TextEditingController();
  final definitionController = TextEditingController();
  String wordForm = "";
  final wordService = WordService();
  final audioPlayer = AudioPlayer();
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);
  final FocusNode wordFocus = FocusNode();
  bool isError = false;
// ValueNotifier<String> wordHintTextNotifier = ValueNotifier<String>('');
  String wordHintText = "";
  int numOfVocab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        surfaceTintColor: Color(0xFFF5F5F5),
        title: Center(
          child: Text(
            "Thư viện từ vựng",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB99B6B),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialOpen,
        buttonSize: Size.fromRadius(30),
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        backgroundColor: AppColors.black_opacity,
        foregroundColor: Colors.white,
        switchLabelPosition: false,
        renderOverlay: true,
        elevation: 8,
        overlayColor: Colors.black45,
        overlayOpacity: 0.2,
        useRotationAnimation: true,
        direction: SpeedDialDirection.up,
        animationCurve: Curves.elasticInOut,
        children: [
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.abc, color: AppColors.cookie),
            labelWidget: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the label
                borderRadius: BorderRadius.circular(30),

                // Optionally, add a border or shadow
              ),
              child: Text(
                "Tạo từ vựng",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: AppColors.cookie,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () => showAddVocabModalBottomSheet(context, wordController,
                definitionController, user, wordHintText, _image, wordForm),
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.topic_outlined, color: AppColors.cookie),
            label: "Thêm topic",
            labelWidget: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the label
                borderRadius: BorderRadius.circular(30),

                // Optionally, add a border or shadow
              ),
              child: Text(
                "Thêm topic",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: AppColors.cookie,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () => showAddTopicModalBottomSheet(context, topicController,
                user, topicService, _btnActive, setState),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleWidget(
              title: "Topics",
            ),
            StreamBuilder<QuerySnapshot>(
              stream: topicService.getTopicsByUserId(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List topics = snapshot.data!.docs;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = topics[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      //Topic's attributes
                      String topicTitle = data['topicName'];

                      return Dismissible(
                        background: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        key: ValueKey(docID),
                        confirmDismiss: (direction) async {
                          final result = await QuickAlert.show(
                            context: context,
                            text: "Bạn có thật sự muốn xóa topic này không ?",
                            type: QuickAlertType.confirm,
                            showCancelBtn: true,
                            confirmBtnText: "Có",
                            cancelBtnText: "Không",
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () async {
                              try {
                                await topicService.deleteTopic(docID);

                                ToastService.showSuccessToast(context,
                                    message: "Xóa topic thành công");
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              } catch (e) {
                                print("Error deleting topic: $e");
                              }
                            },
                          );

                          return result;
                        },
                        child: TopicCard(
                          // onTap: () => showTopicDetail(context, data, docID),
                          onTap: () async => {
                            Navigator.of(context, rootNavigator: true)
                                .push(PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: DetailTopic(
                                      data: data,
                                      docID: docID,
                                    ))),
                          },
                          topicName: topicTitle,
                          numOfVocab: 1,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No Topics Found"));
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TitleWidget(
              title: "Từ vựng",
            ),
            StreamBuilder<QuerySnapshot>(
                stream: wordService.getWordsByUserId(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List words = snapshot.data!.docs;
                    words.sort((a, b) {
                      return b['date'].compareTo(a['date']);
                    });
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: words.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = words[index];
                          String wordId = document.id;
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          String word = data['word'];
                          String definition = data['definition'];
                          String phonetic = data['phonetic'];
                          String date = data['date'];
                          String image = data['image'];
                          String wordForm = data['wordForm'];
                          String example = data['example'];
                          String audio = data['audio'];
                          bool isFav = data['isFav'];
                          String topicId = data['topicId'];
                          int status = data['status'];
                          String userId = data['userId'];

                          return Dismissible(
                            background: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            key: ValueKey(wordId),
                            child: VocabularyCard(
                              word: word,
                              phonetics:
                                  phonetic != "" ? phonetic : "/transcription/",
                              definition: definition,
                              wordForm: wordForm,
                              date: date,
                              isFav: isFav,
                              topicId: topicId,
                              onSpeakerPressed: () async {
                                await audioPlayer.stop();
                                await audioPlayer.play(UrlSource(audio));
                              },
                              onFavoritePressed: (bool isFav) async {
                                await wordService.updateFavorite(wordId, isFav);
                                return !isFav;
                              },
                              onSavePressed: () {
                                showTopicsModalBottomSheet(
                                    context,
                                    wordId,
                                    word,
                                    definition,
                                    phonetic,
                                    date,
                                    image,
                                    wordForm,
                                    example,
                                    audio,
                                    isFav,
                                    topicId,
                                    status,
                                    userId);
                              },
                              onTap: () {
                                showDetailVocabModalBottomSheet(
                                  context,
                                  wordId,
                                  word,
                                  phonetic,
                                  definition,
                                  File(image),
                                  audio,
                                  example,
                                  user,
                                  topicService,
                                  wordForm,
                                );
                              },
                            ),
                            confirmDismiss: (direction) async {
                              final result = await QuickAlert.show(
                                context: context,
                                text:
                                    "Bạn có thật sự muốn xóa từ vựng này không ?",
                                type: QuickAlertType.confirm,
                                showCancelBtn: true,
                                confirmBtnText: "Có",
                                cancelBtnText: "Không",
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () async {
                                  try {
                                    await wordService.deleteWord(wordId);

                                    ToastService.showSuccessToast(context,
                                        message: "Xóa $word thành công");
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  } catch (e) {
                                    print("Error deleting word: $e");
                                  }
                                },
                              );

                              return result;
                            },
                          );
                        });
                  } else {
                    return Center(child: Text("No Words Found"));
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    topicController.dispose();
    definitionController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}
