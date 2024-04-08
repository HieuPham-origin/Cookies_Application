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
import 'package:cookie_app/pages/favorite_vocabularies_page.dart';
import 'package:cookie_app/pages/folder_page.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';

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
  int numOfVocabInTopic = 0;
  int numOfTopic = 0;
  int numOfVocab = 0;

  @override
  void initState() {
    super.initState();
    topicService.countTopics(user.uid).then((value) {
      setState(() {
        numOfTopic = value;
      });
    });

    wordService.countWords(user.uid).then((value) {
      setState(() {
        numOfVocab = value;
      });
    });
  }

  void updateState(int numOfVocabInTopic) {
    setState(() {
      this.numOfVocabInTopic = numOfVocabInTopic;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.coffee,
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
            child: Icon(CupertinoIcons.textformat_alt, color: AppColors.cookie),
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
            onTap: () => showAddVocabModalBottomSheet(
                context,
                wordController,
                definitionController,
                user,
                wordHintText,
                _image,
                wordForm, (int numOfVocab) {
              setState(() {
                this.numOfVocab = numOfVocab;
              });
            }, numOfVocab),
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(CupertinoIcons.bookmark_fill,
                color: Colors.yellow.shade700),
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
                "Tạo topic",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: Colors.yellow.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () => showAddTopicModalBottomSheet(
                context,
                topicController,
                user,
                topicService,
                setState,
                (String topicName) {}, (int numOfTopic) {
              setState(() {
                this.numOfTopic = numOfTopic;
              });
            }, numOfTopic, "", 1),
          ),
          SpeedDialChild(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Ink(
                  child:
                      Icon(CupertinoIcons.folder_fill, color: AppColors.blue)),
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
                  "Thư mục",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              onTap: () => {
                    Navigator.of(context, rootNavigator: true).push(
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: FolderPage()),
                    )
                  }),
          SpeedDialChild(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Ink(
                  child: Icon(CupertinoIcons.heart_fill, color: AppColors.red)),
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
                  "Từ yêu thích",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              onTap: () => {
                    Navigator.of(context, rootNavigator: true).push(
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: FavoriteVocabPage()),
                    )
                  }),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                TitleWidget(
                  title: "Topics",
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: Dimensions.height(context, 30),
                  width: Dimensions.width(context, 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cookie,
                  ),
                  child: Center(
                    child: Text(
                      numOfTopic.toString(),
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: topicService.getTopicsByUserId(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List topics = snapshot.data!.docs;
                  if (topics.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        Container(
                          height: screenSize.height * 0.18,
                          width: screenSize.width * 0.3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/logo_icon_removebg.png'),
                            fit: BoxFit.contain,
                          )),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showAddTopicModalBottomSheet(
                                context,
                                topicController,
                                user,
                                topicService,
                                setState,
                                (String topicName) {}, (int numOfTopic) {
                              setState(() {
                                this.numOfTopic = numOfTopic;
                              });
                            }, numOfTopic, "", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.creamy,
                            foregroundColor: AppColors.cookie,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Tạo topic đầu tiên"),
                        ),
                      ],
                    ));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = topics[index];
                      String docID = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      // Topic's attributes
                      String topicTitle = data['topicName'];

                      return FutureBuilder<int>(
                        future: topicService.countWordsInTopic(docID),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int numOfVocabInTopicLibrary = snapshot.data ?? 0;

                            return Slidable(
                              key: ValueKey(docID),
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                extentRatio: 0.3,
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    autoClose: true,
                                    onPressed: (direction) async {
                                      await QuickAlert.show(
                                          context: context,
                                          text:
                                              "Bạn có thật sự muốn xóa topic này không ?",
                                          type: QuickAlertType.confirm,
                                          showCancelBtn: true,
                                          confirmBtnText: "Có",
                                          cancelBtnText: "Không",
                                          confirmBtnColor: Colors.red,
                                          onCancelBtnTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          },
                                          onConfirmBtnTap: () async {
                                            await topicService
                                                .deleteTopic(docID);
                                            setState(() {
                                              numOfTopic -= 1;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          });
                                    },
                                    backgroundColor: AppColors.red,
                                    icon: Icons.delete,
                                    label: 'Xóa',
                                  ),
                                ],
                              ),
                              child: TopicCard(
                                onTap: () async => {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: DetailTopic(
                                            data: data,
                                            docID: docID,
                                            numOfVocabInTopic:
                                                numOfVocabInTopic,
                                            numOfVocab: numOfVocab,
                                            setNumOfVocabInTopicFromLibrary:
                                                (int numOfVocabInTopic) {
                                              setState(() {
                                                this.numOfVocabInTopic =
                                                    numOfVocabInTopic;
                                              });
                                            },
                                            setNumOfVocab: (int numOfVocab) {
                                              setState(() {
                                                this.numOfVocab = numOfVocab;
                                              });
                                            },
                                          ))),
                                },
                                topicName: topicTitle,
                                numOfVocab: numOfVocabInTopicLibrary,
                              ),
                            );
                          }
                        },
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
            Row(
              children: [
                TitleWidget(
                  title: "Từ vựng",
                ),
                Container(
                  height: Dimensions.height(context, 30),
                  width: Dimensions.width(context, 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cookie,
                  ),
                  child: Center(
                    child: Text(
                      numOfVocab.toString(),
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

                    if (words.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          Container(
                            height: screenSize.height * 0.18,
                            width: screenSize.width * 0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage('assets/logo_icon_removebg.png'),
                              fit: BoxFit.contain,
                            )),
                          ),
                          Text("Không có từ vựng nào",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.grey_light)),
                          ElevatedButton(
                            onPressed: () {
                              showAddVocabModalBottomSheet(
                                  context,
                                  wordController,
                                  definitionController,
                                  user,
                                  wordHintText,
                                  _image,
                                  wordForm, (int numOfVocab) {
                                setState(() {
                                  this.numOfVocab = numOfVocab;
                                });
                              }, numOfVocab);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.creamy,
                              foregroundColor: AppColors.cookie,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text("Tạo từ vựng đầu tiên"),
                          ),
                        ],
                      ));
                    }
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

                          return Slidable(
                            key: ValueKey(wordId),
                            closeOnScroll: true,
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  autoClose: true,
                                  onPressed: (direction) async {
                                    await QuickAlert.show(
                                        context: context,
                                        text:
                                            "Bạn có thật sự muốn xóa từ vựng này không ?",
                                        type: QuickAlertType.confirm,
                                        showCancelBtn: true,
                                        confirmBtnText: "Có",
                                        cancelBtnText: "Không",
                                        confirmBtnColor: Colors.red,
                                        onCancelBtnTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                        onConfirmBtnTap: () async {
                                          await wordService.deleteWord(wordId);
                                          setState(() {
                                            numOfVocab -= 1;
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        });
                                  },
                                  backgroundColor: AppColors.red,
                                  icon: Icons.delete,
                                  label: 'Xóa',
                                ),
                              ],
                            ),
                            child: VocabularyCard(
                              word: word,
                              phonetics:
                                  phonetic != "" ? phonetic : "/transcription/",
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
                                  userId,
                                  (int numOfVocabInTopic) {
                                    setState(() {
                                      this.numOfVocabInTopic =
                                          numOfVocabInTopic;
                                    });
                                  },
                                  numOfVocabInTopic,
                                  (int numOfVocab) {
                                    setState(() {
                                      this.numOfVocab = numOfVocab;
                                    });
                                  },
                                  numOfVocab,
                                );
                              },
                              onTap: () {
                                showDetailVocabModalBottomSheet(
                                  context,
                                  topicId,
                                  wordId,
                                  word,
                                  phonetic,
                                  date,
                                  definition,
                                  File(image),
                                  audio,
                                  example,
                                  user,
                                  topicService,
                                  wordForm,
                                  (int numOfVocabInTopic) {
                                    setState(() {
                                      this.numOfVocabInTopic =
                                          numOfVocabInTopic;
                                    });
                                  },
                                  numOfVocabInTopic,
                                  (int numOfVocab) {
                                    setState(() {
                                      this.numOfVocab = numOfVocab;
                                    });
                                  },
                                  numOfVocab,
                                );
                              },
                            ),
                          );
                        });
                  } else {
                    return Center(child: Text("No Words Found"));
                  }
                }),
            SizedBox(
              height: Dimensions.height(context, 80),
            ),
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
