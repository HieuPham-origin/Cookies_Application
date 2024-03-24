// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/custome_segment_button.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_app/components/title_widget.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/model/topic.dart';
import 'package:cookie_app/model/word.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import the 'intl' package
import 'package:audioplayers/audioplayers.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  File? _image;

  Future _pickImageFromLibrary(StateSetter setModalState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setModalState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _pickImageFromCamera(StateSetter setModalState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    setModalState(() {
      _image = File(pickedFile.path);
    });
  }

  final topicController = TextEditingController();
  final topicService = TopicService();
  final user = FirebaseAuth.instance.currentUser!;
  bool _btnActive = false;

  final wordController = TextEditingController();
  final definitionController = TextEditingController();
  String wordForm = "";
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final wordService = WordService();
  final audioPlayer = AudioPlayer();
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);
  final FocusNode wordFocus = FocusNode();
  bool isError = false;
// ValueNotifier<String> wordHintTextNotifier = ValueNotifier<String>('');
  String wordHintText = "";
  @override
  void initState() {
    super.initState();
  }

  void _showAddTopicModalBottomSheet(BuildContext context) {
    topicController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen),
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56.0,
                      child: Center(
                          child: Text(
                        "Thêm Topic",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: IconButton(
                        icon: Icon(Icons.close, size: 28),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: topicController,
                    onChanged: (value) {
                      setState(() {
                        _btnActive = value.isNotEmpty ? true : false;
                      });
                    },
                    autofocus: true,
                    style: GoogleFonts.inter(),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.cookie),
                      ),
                      label: Text("Tên Topic"),
                      floatingLabelStyle: TextStyle(
                        color: AppColors.cookie,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _btnActive == true
                        ? () async {
                            Topic topic = Topic(
                                topicName: topicController.text,
                                isPublic: false,
                                userId: user.uid,
                                userEmail: user.email);
                            try {
                              await topicService.addTopic(topic);
                              ToastService.showSuccessToast(context,
                                  message: "Add topic thành công");
                              Navigator.pop(context);
                            } catch (e) {
                              print('Failed to add topic: $e');
                              // Optionally, show an error toast or dialog
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99B6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      "Thêm Topic",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTopicDetail(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      useRootNavigator: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: ((context) => FractionallySizedBox(
            heightFactor: 0.95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56.0,
                        child: Center(
                            child: Text(
                          data['topicName'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          icon: Icon(Icons.close, size: 28),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

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
      throw Exception('Phonetic text not found');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load phonetic values');
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
                  print(definition['example']);
                  return definition['example'];
                }
              }
            }
          }
        }
      }
      throw Exception('Example not found');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load example');
    }
  }

  void handleSelectionChange(WordForm selectedForm) {
    wordForm = selectedForm.toString().split('.').last;
  }

  void _showAddVocabModalBottomSheet(BuildContext context) {
    wordController.clear();
    definitionController.clear();
    _image = null;
    wordHintText = "";

    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        useRootNavigator: true,
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        backgroundColor: Colors.white,
        builder: (context) => StatefulBuilder(builder: (BuildContext context,
                StateSetter setModalState /*You can rename this!*/) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.95,
                builder: (context, scrollController) => Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setModalState(() {
                                    _image = null;
                                  });
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.cookie,
                                  ),
                                ),
                              ),
                              Text(
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
                                    setModalState(() {
                                      wordHintText =
                                          "Từ vựng không được để trống";
                                    });

                                    return;
                                  }

                                  Word word = Word(
                                    word: wordController.text,
                                    definition: definitionController.text,
                                    phonetic: await getPhoneticValues(
                                        wordController.text),
                                    date: getCurrentDate(),
                                    image: _image!.path,
                                    wordForm:
                                        wordForm == "" ? "noun" : wordForm,
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
                                    ToastService.showSuccessToast(context,
                                        message: "Add từ vựng thành công");
                                    Navigator.pop(context);
                                  } catch (e) {
                                    print('Failed to add word: $e');
                                    // Optionally, show an error toast or dialog
                                  }
                                },
                                child: Text(
                                  "Tiếp",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.cookie,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: wordController,
                            autofocus: true,
                            style: TextStyle(
                              fontFamily: 'Inter',
                            ),
                            decoration: InputDecoration(
                              hintText: wordHintText,
                              hintStyle: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.normal,
                              ),
                              contentPadding: EdgeInsets.only(bottom: 0),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.cookie),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            textAlign: TextAlign.start,
                            controller: definitionController,
                            onChanged: (value) {
                              setState(() {
                                _btnActive = value.isNotEmpty ? true : false;
                              });
                            },
                            style: GoogleFonts.inter(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 0),
                              suffixIconConstraints:
                                  BoxConstraints(maxHeight: 24, maxWidth: 24),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.only(bottom: 0),
                                onPressed: () {
                                  //show camera option
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(0))),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 112,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Chụp ảnh"),
                                                onTap: () {
                                                  //open camera
                                                  _pickImageFromCamera(
                                                      setModalState);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.image),
                                                title: Text(
                                                    "Chọn ảnh từ thư viện"),
                                                onTap: () {
                                                  //open gallery
                                                  _pickImageFromLibrary(
                                                      setModalState);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.cookie),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
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
                    ),
                    CustomeSegmentButton(
                      onSelectionChanged: handleSelectionChange,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      height: 250,
                      child: _image != null ? Image.file(_image!) : Container(),
                    ),
                  ],
                ),
              );
            }));
  }

  void showTopicsModalBottomSheet(
      BuildContext context,
      String wordId,
      String word,
      String definition,
      String phonetic,
      String date,
      String image,
      String wordForm,
      String example,
      String audio,
      bool isFav,
      String topicId,
      int status,
      String userId) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        useRootNavigator: true,
        isDismissible: false,
        context: context,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              shouldCloseOnMinExtent: true,
              initialChildSize: 0.95,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withOpacity(0.1),
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
                            child: Text(
                              "Hủy",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.cookie,
                              ),
                            ),
                          ),
                          Text(
                            "Thêm vào Topic",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.cookie,
                            ),
                          ),
                          InkWell(
                            onTap: () async {},
                            child: Text(
                              "Tạo mới",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.cookie,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: StreamBuilder<QuerySnapshot>(
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

                                  return TopicCard(
                                    onTap: () => {
                                      addWordToTopic(() {
                                        Navigator.of(context).pop();
                                      },
                                          docID,
                                          wordId,
                                          Word(
                                            word: word,
                                            definition: definition,
                                            phonetic: phonetic,
                                            date: date,
                                            image: image,
                                            wordForm: wordForm,
                                            example: example,
                                            audio: audio,
                                            isFav: isFav,
                                            topicId: docID,
                                            status: status,
                                            userId: userId,
                                          )),
                                    },
                                    topicName: topicTitle,
                                    numOfVocab: 1,
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text("No Topics Found"));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ));
  }

  void addWordToTopic(void Function() popCallback, String topicId,
      String wordId, Word word) async {
    try {
      await topicService.addWordToTopic(topicId, wordId, word);
      await wordService.deleteWord(wordId);
      // Check if the widget is still mounted before popping the context
      if (mounted) {
        popCallback();
      }
    } catch (e) {
      print('Failed to add word to topic: $e');
      // Optionally, show an error toast or dialog
    }
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
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.topic, color: AppColors.cookie),
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
            onTap: () => _showAddTopicModalBottomSheet(context),
          ),
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
              onTap: () => _showAddVocabModalBottomSheet(context)),
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
                          onTap: () => showTopicDetail(context, data),
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
                  if (snapshot.hasData) {
                    List words = snapshot.data!.docs;
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
                              phonetics: phonetic,
                              definition: definition,
                              wordForm: wordForm,
                              date: date,
                              onSpeakerPressed: () async {
                                await audioPlayer.stop();
                                await audioPlayer.play(UrlSource(audio));
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
    super.dispose();
  }
}
