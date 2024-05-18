// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_topic_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/folder_option.dart';
import 'package:cookie_app/components/modal_bottom_sheet/practice_option.dart';
import 'package:cookie_app/components/modal_bottom_sheet/topic_option.dart';
import 'package:cookie_app/components/modal_bottom_sheet/vocabulary_option.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/pages/practice_pages/quiz_screen.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

class DetailTopic extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docID;
  int numOfVocabInTopicInFolder;
  int numOfVocabInTopic;
  int numOfVocab;
  int numOfTopic;
  void Function(int) setNumOfTopic;
  void Function(int) setNumOfVocab;
  void Function(int) setNumOfVocabInTopicFromLibrary;
  void Function(int) setNumOfTopicInFolder;

  DetailTopic({
    super.key,
    required this.data,
    required this.docID,
    required this.numOfVocabInTopic,
    required this.numOfVocabInTopicInFolder,
    required this.numOfVocab,
    required this.numOfTopic,
    required this.setNumOfTopic,
    required this.setNumOfTopicInFolder,
    required this.setNumOfVocab,
    required this.setNumOfVocabInTopicFromLibrary,
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
String userId = FirebaseAuth.instance.currentUser!.uid;

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

  Future<void> exportTopic() async {
    final topicName = widget.data['topicName'];

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("Yoooooo");
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/$topicName.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true); 
    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    String topicName = widget.data['topicName'];
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
          centerTitle: false,
          title: Text(
            "Topic",
            style: TextStyle(
              color: AppColors.icon_grey,
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
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints:
                  BoxConstraints(maxWidth: Dimensions.width(context, 30)),
              icon: Icon(CupertinoIcons.folder_badge_plus,
                  color: AppColors.grey_heavy), // Adjust the color as needed
              onPressed: () {
                // Add your onPressed action here
                HapticFeedback.vibrate();
                showFolderModalBottomSheet(
                    context,
                    widget.docID,
                    Topic(
                      topicName: topicName,
                      isPublic: false,
                      userId: user.uid,
                      userEmail: user.email,
                      color: widget.data['color'],
                    ),
                    widget.setNumOfTopic,
                    widget.numOfTopic);
              },
            ),
            IconButton(
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints:
                  BoxConstraints(maxWidth: Dimensions.width(context, 30)),
              icon: Icon(CupertinoIcons.add,
                  color: AppColors.grey_heavy), // Adjust the color as needed
              onPressed: () {
                // Add your onPressed action here
                HapticFeedback.vibrate();
                showVocabulariesModalBottomSheet(
                  context,
                  widget.docID,
                  (int numOfWord1) {
                    setState(() {
                      numOfWord = numOfWord1;
                    });
                  },
                  numOfWord,
                  widget.setNumOfVocabInTopicFromLibrary,
                  widget.numOfVocab,
                  widget.setNumOfVocab,
                  widget.numOfVocabInTopicInFolder,
                  widget.setNumOfTopicInFolder,
                );
              },
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
                showAddTopicModalBottomSheet(
                  context,
                  TextEditingController(text: topicName),
                  user,
                  topicService,
                  setState,
                  (String topicName) {
                    setState(() {
                      widget.data['topicName'] = topicName;
                    });
                  },
                  (String color) {
                    setState(() {
                      widget.data['color'] = color;
                    });
                  },
                  widget.setNumOfVocabInTopicFromLibrary,
                  widget.numOfVocabInTopic,
                  widget.docID,
                  2,
                );
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
            IconButton(
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints:
                  BoxConstraints(maxWidth: Dimensions.width(context, 20)),
              icon: Icon(CupertinoIcons.share,
                  color: AppColors.grey_heavy), // Adjust the color as needed
              onPressed: () {
                // Add your onPressed action here
                HapticFeedback.vibrate();
                exportTopic();
              },
            ),
          ],
        ),
      ),
      body: numOfWord == -1
          ? const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(
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
                                topicName,
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
                                "$numOfWord từ",
                                style: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 16),
                                  color: AppColors.cookie,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                AppColors.cookie,
                                Color.fromARGB(204, 185, 155, 107),
                              ])),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(200, 40),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              showPracticeptionModalBottomSheet(
                                  context, widget.docID, widget.data);
                            },
                            child: const Text("Luyện tập"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.data['color'] == 'red'
                            ? AppColors.red
                            : widget.data['color'] == 'green'
                                ? AppColors.green
                                : widget.data['color'] == 'blue'
                                    ? AppColors.blue
                                    : widget.data['color'] == 'yellow'
                                        ? AppColors.yellow
                                        : widget.data['color'] == 'orange'
                                            ? AppColors.orange
                                            : widget.data['color'] == 'grey'
                                                ? AppColors.grey_light
                                                : widget.data['color'] ==
                                                        'purple'
                                                    ? AppColors.purple
                                                    : AppColors.coffee,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: topicService.getWordsForTopicStream(widget.docID),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // print(snapshot.error);
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List words = snapshot.data!.docs;
                          if (words.isEmpty) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenSize.height * 0.18,
                                  width: screenSize.width * 0.3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage(
                                        'assets/logo_icon_removebg.png'),
                                    fit: BoxFit.contain,
                                  )),
                                ),
                                Text("Không có từ vựng nào",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.grey_light)),
                              ],
                            ));
                          }
                          words.sort((a, b) {
                            return b['date'].compareTo(a['date']);
                          });

                          return ListView.builder(
                              itemCount: words.length,
                              shrinkWrap: true,
                              itemBuilder: (contextVocab, index) {
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

                                return Slidable(
                                  closeOnScroll: true,
                                  key: Key(wordId),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        autoClose: true,
                                        onPressed: (direction) async {
                                          final result = await QuickAlert.show(
                                              context: contextVocab,
                                              text:
                                                  "Bạn có thật sự muốn xóa từ vựng này không ?",
                                              type: QuickAlertType.confirm,
                                              showCancelBtn: true,
                                              confirmBtnText: "Có",
                                              cancelBtnText: "Không",
                                              confirmBtnColor: Colors.red,
                                              onCancelBtnTap: () {
                                                Navigator.of(contextVocab,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              },
                                              onConfirmBtnTap: () async {
                                                await topicService
                                                    .deleteWordForTopic(
                                                        widget.docID, wordId);
                                                setState(() {
                                                  numOfWord -= 1;
                                                });
                                                widget.setNumOfVocabInTopicFromLibrary(
                                                    widget.numOfVocabInTopic -
                                                        1);
                                                widget.setNumOfTopicInFolder(
                                                    widget.numOfVocabInTopicInFolder -
                                                        1);

                                                Navigator.of(contextVocab,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              });

                                          return result;
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: AppColors.red,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
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
                                    type: 1,
                                    onSpeakerPressed: () async {
                                      await audioPlayer.stop();
                                      await audioPlayer.play(UrlSource(audio));
                                    },
                                    onFavoritePressed: (bool isFav) async {
                                      if (!isFav) {
                                        await topicService
                                            .updateFavoriteWordForTopic(
                                                widget.docID, wordId, isFav);
                                        await wordService.addFavoriteWord(
                                            Word(
                                                word: word,
                                                definition: definition,
                                                phonetic: phonetic,
                                                date: date,
                                                image: image,
                                                wordForm: wordForm,
                                                example: example,
                                                audio: audio,
                                                isFav: !isFav,
                                                topicId: topicId,
                                                status: status,
                                                userId: userId),
                                            wordId);
                                      } else {
                                        await topicService
                                            .updateFavoriteWordForTopic(
                                                widget.docID, wordId, isFav);
                                        await wordService
                                            .removeFavoriteWord(wordId);
                                      }
                                      return null;
                                    },
                                    onSavePressed: () {
                                      showTopicsModalBottomSheet(
                                        contextVocab,
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
                                        userId,
                                        (int numOfVocabInTopic) {
                                          widget
                                              .setNumOfVocabInTopicFromLibrary(
                                                  numOfVocabInTopic);
                                        },
                                        widget.numOfVocabInTopic,
                                        (int numOfVocab) {
                                          setState(() {
                                            widget.numOfVocab = numOfVocab;
                                          });
                                        },
                                        widget.numOfVocab,
                                      );
                                    },
                                    onTap: () {
                                      showDetailVocabModalBottomSheet(
                                        contextVocab,
                                        widget.docID,
                                        wordId,
                                        word,
                                        phonetic,
                                        date,
                                        definition,
                                        image,
                                        audio,
                                        example,
                                        wordForm,
                                        user: user,
                                        topicService: topicService,
                                        numOfVocabInTopic:
                                            widget.numOfVocabInTopic,
                                        setNumOfVocabInTopic:
                                            (int numOfVocabInTopic) {
                                          widget
                                              .setNumOfVocabInTopicFromLibrary(
                                                  numOfVocabInTopic);
                                        },
                                        setNumOfVocab: (int numOfVocab) {
                                          setState(() {
                                            widget.numOfVocab = numOfVocab;
                                          });
                                        },
                                        numOfVocab: widget.numOfVocab,
                                      );
                                    },
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("No Words Found"));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
