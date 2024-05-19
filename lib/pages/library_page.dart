// ignore_for_file: prefer_const_constructors
import 'dart:developer';
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
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/pages/library_page/favorite_vocabularies_page.dart';
import 'package:cookie_app/pages/library_page/folder_page.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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

  bool isDataChange = false;
  int isInit = 0;

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> importExcel() async {
    try {
      // Pick an Excel file.
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) {
        // User canceled the picker.
        return;
      }

      // Get the selected file.
      File file = File(result.files.single.path!);
      final List<int> bytes = await file.readAsBytes();

      // Decode the Excel file.
      var excel = Excel.decodeBytes(bytes);

      // Extract the topic name from the file name.
      String topicName = result.files.single.name.split('.').first;

      // Get the current user.
      var user = FirebaseAuth.instance.currentUser;

      // Add the new topic to Firestore.
      var newTopic = {
        'topicName': topicName,
        'isPublic': false,
        'userId': user!.uid,
        'userEmail': user.email,
        'color': "default", // Set the default or your desired color
      };

      DocumentReference topicRef =
          await _firestore.collection('topics').add(newTopic);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          List<Data?> row = sheet.rows[rowIndex];

          String word = row[0]?.value?.toString() ?? '';
          String definition = row[1]?.value?.toString() ?? '';
          String phonetic = row[2]?.value?.toString() ?? '';
          String date = row[3]?.value?.toString() ?? '';
          String wordForm = row[4]?.value?.toString() ?? '';
          String example = row[5]?.value?.toString() ?? '';

          var newWord = {
            'word': word,
            'definition': definition,
            'phonetic': phonetic,
            'date': date,
            'wordForm': wordForm,
            'example': example,
            'topicId': topicRef.id,
            'isFav': false,
            'audio':
                'https://translate.google.com/translate_tts?ie=UTF-8&q=%22"$word"&tl=en&client=tw-ob',
            'status': 0,
            'image': '',
            'userId': user.uid,
          };

          await _firestore
              .collection('topics')
              .doc(topicRef.id)
              .collection('words')
              .add(newWord);
        }
      }

      log('Excel file imported successfully');
      setState(() {
        numOfTopic++;
      });
    } catch (e) {
      print('Error importing Excel file: $e');
    }
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Ink(
                child: Icon(Icons.import_export_rounded,
                    color: AppColors.black_opacity)),
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
                "Nhập topic từ file",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: AppColors.black_opacity,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onTap: () async {
              await importExcel();
            },
          ),
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
                  child: FavoriteVocabPage(),
                ),
              )
            },
          ),
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
                (String topicName) {},
                (String color) {}, (int numOfTopic) {
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
                child: Icon(CupertinoIcons.folder_fill, color: AppColors.blue)),
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
                    child: FolderPage(
                      numOfVocabInTopic: numOfVocabInTopic,
                      numOfVocab: numOfVocab,
                      numOfTopic: numOfTopic,
                      setNumOfTopic: (int numOfTopic) {
                        setState(() {
                          this.numOfTopic = numOfTopic;
                        });
                      },
                      setNumOfVocabInTopicFromLibrary: (int numOfVocabInTopic) {
                        setState(() {
                          this.numOfVocabInTopic = numOfVocabInTopic;
                        });
                      },
                      setNumOfVocab: (int numOfVocab) {
                        setState(() {
                          this.numOfVocab = numOfVocab;
                        });
                      },
                    )),
              )
            },
          ),
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
                                (String topicName) {},
                                (String color) {}, (int numOfTopic) {
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
                      String color = data['color'];

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
                                            numOfVocabInTopicInFolder: 0,
                                            setNumOfTopicInFolder: (p0) {},
                                            numOfTopic: numOfTopic,
                                            setNumOfTopic: (int numOfTopic) {
                                              setState(() {
                                                this.numOfTopic = numOfTopic;
                                              });
                                            },
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
                                color: color,
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
                                if (!isFav) {
                                  await wordService.updateFavorite(
                                      wordId, isFav);
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
                                  await wordService.updateFavorite(
                                      wordId, isFav);
                                  await wordService.removeFavoriteWord(wordId);
                                }
                                return null;
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
                                  image,
                                  audio,
                                  example,
                                  wordForm,
                                  user: user,
                                  topicService: topicService,
                                  setNumOfVocabInTopic:
                                      (int numOfVocabInTopic) {
                                    setState(() {
                                      this.numOfVocabInTopic =
                                          numOfVocabInTopic;
                                    });
                                  },
                                  numOfVocab: numOfVocab,
                                  setNumOfVocab: (int numOfVocab) {
                                    setState(() {
                                      this.numOfVocab = numOfVocab;
                                    });
                                  },
                                  numOfVocabInTopic: numOfVocabInTopic,
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
