import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toasty_box/toast_service.dart';

class DetailTopic extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docID;
  const DetailTopic({
    super.key,
    required this.data,
    required this.docID,
  });
  @override
  State<DetailTopic> createState() => _DetailTopicState();
}

String edit = "Sửa";
final topicService = TopicService();
int numOfWord = -1;
final user = FirebaseAuth.instance.currentUser!;
final wordService = WordService();
final audioPlayer = AudioPlayer();

class _DetailTopicState extends State<DetailTopic> {
  @override
  void initState() {
    super.initState();
    // Add your initialization logic here
    numOfWord = -1;
    topicService.countWordsInTopic(widget.docID).then((value) {
      setState(() {
        numOfWord = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            Dimensions.height(context, Dimensions.height(context, 50))),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Container(
              color: AppColors.grey_light,
              height: 0.2,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Topic",
            style: TextStyle(
              color: AppColors.grey_heavy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.grey_heavy),
            onPressed: () {
              // Add your onPressed action here
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add,
                  color: AppColors.grey_heavy), // Adjust the color as needed
              onPressed: () {
                // Add your onPressed action here
                HapticFeedback.vibrate();
              },
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16), // Add padding if necessary
                alignment: Alignment.center,
                child: Text(
                  "Sửa",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.icon_grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: numOfWord == -1
          ? Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: const CircularProgressIndicator(
                  backgroundColor: AppColors.background,
                  strokeCap: StrokeCap.round,
                  color: AppColors.cookie,
                ),
              ),
            )
          : Container(
              // padding: const EdgeInsets.all(10.0),
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                widget.data['topicName'],
                                style: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 24),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cookie,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.creamy,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${numOfWord} từ",
                                style: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 16),
                                  color: AppColors.cookie,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SwipeCard(
                                topidId: widget.docID,
                              ),
                            ),
                          ),
                          child: const Text("Flashcard"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.red,
                      ),
                    ),
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                        stream:
                            topicService.getWordsForTopicStream(widget.docID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List words = snapshot.data!.docs;
                            words.sort((a, b) {
                              return b['date'].compareTo(a['date']);
                            });
                            return ListView.builder(
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppColors.red,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 24.0),
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
                                      phonetics: phonetic != ""
                                          ? phonetic
                                          : "/transcription/",
                                      definition: definition,
                                      wordForm: wordForm,
                                      date: date,
                                      isFav: isFav,
                                      topicId: topicId,
                                      onSpeakerPressed: () async {
                                        await audioPlayer.stop();
                                        await audioPlayer
                                            .play(UrlSource(audio));
                                      },
                                      onFavoritePressed: (bool isFav) async {
                                        await wordService.updateFavorite(
                                            wordId, isFav);
                                        return !isFav;
                                      },
                                      onSavePressed: () {
                                        // showTopicsModalBottomSheet(
                                        //     context,
                                        //     wordId,
                                        //     word,
                                        //     definition,
                                        //     phonetic,
                                        //     date,
                                        //     image,
                                        //     wordForm,
                                        //     example,
                                        //     audio,
                                        //     isFav,
                                        //     topicId,
                                        //     status,
                                        //     userId);
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
                                            await wordService
                                                .deleteWord(wordId);

                                            ToastService.showSuccessToast(
                                                context,
                                                message:
                                                    "Xóa $word thành công");
                                            Navigator.of(context,
                                                    rootNavigator: true)
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
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
