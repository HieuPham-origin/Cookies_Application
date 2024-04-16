import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/folder_card.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_folder_model.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_folder_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/topic_option.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/FolderService.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  int numOfVocabInTopic;
  int numOfVocab;
  int numOfTopic;
  void Function(int) setNumOfTopic;
  void Function(int) setNumOfVocab;
  void Function(int) setNumOfVocabInTopicFromLibrary;

  FolderPage({
    super.key,
    required this.numOfVocabInTopic,
    required this.numOfVocab,
    required this.numOfTopic,
    required this.setNumOfTopic,
    required this.setNumOfVocab,
    required this.setNumOfVocabInTopicFromLibrary,
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}

WordService wordService = WordService();
final folderService = FolderService();
final topicService = TopicService();
final user = FirebaseAuth.instance.currentUser!;
List<String> topicId = [];
List<Word> words = [];

class _FolderPageState extends State<FolderPage> {
  StreamSubscription? wordSubscription;
  List<Word> combinedWords = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    topicService.getTopicIdList(user.uid).then((value) {
      setState(() {
        topicId = value;
      });

      topicService.getAllFavoriteWords(topicId).then((value) {
        combinedWords.addAll(value);

        wordSubscription =
            wordService.getFavoriteWordsByUserId(user.uid).listen((event) {
          combinedWords
              .addAll(event.docs.map((e) => Word.fromSnapshot(e)).toList());

          setState(() {
            words = combinedWords;
          });
        });
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
          forceMaterialTransparency: true,
          title: Text(
            "Thư mục",
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
                // HapticFeedback.vibrate();
                showAddFolderModalBottomSheet(context, user);
              },
            ),
            GestureDetector(
              onTap: () {
                // HapticFeedback.vibrate();
                // showAddTopicModalBottomSheet(
                //   context,
                //   TextEditingController(text: topicName),
                //   user,
                //   topicService,
                //   setState,
                //   (String topicName) {
                //     setState(() {
                //       widget.data['topicName'] = topicName;
                //     });
                //   },
                //   widget.setNumOfVocabInTopicFromLibrary,
                //   widget.numOfVocabInTopic,
                //   widget.docID,
                //   2,
                // );
              },
              child: Container(
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: 16), // Add padding if necessary
                  // alignment: Alignment.center,
                  // child: Text(
                  //   "Sửa",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w500,
                  //     color: AppColors.icon_grey,
                  //   ),
                  // ),
                  ),
            ),
          ],
        ),
      ),
      body: words.isEmpty
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
          : Center(
              child: Container(
                padding: EdgeInsets.all(Dimensions.width(context, 25)),
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: folderService.getAll(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                      if (snapshot.hasData) {
                        List folder = snapshot.data!.docs;

                        return Wrap(
                          spacing: Dimensions.width(
                              context, 30), // adjust spacing as needed
                          runSpacing:
                              20, // adjust spacing between rows as needed
                          children: List.generate(
                            folder.length,
                            (index) {
                              DocumentSnapshot folderData = folder[index];
                              String folderName = folderData['folderName'];
                              // You can also retrieve other properties as needed

                              return FolderCard(
                                folderName: folderName,
                                numOfTopic: 0,
                                onTap: () {
                                  showDetailFolderModalBottomSheet(
                                      context,
                                      folderName,
                                      folderData.id,
                                      widget.numOfVocabInTopic,
                                      widget.numOfVocab,
                                      widget.numOfTopic,
                                      widget.setNumOfTopic,
                                      widget.setNumOfVocab,
                                      widget.setNumOfVocabInTopicFromLibrary);
                                },
                                onTapDelete: () {
                                  folderService.deleteFolder(folderData.id);
                                },
                                type: 1,
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator(); // Or any loading indicator
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    wordSubscription?.cancel();
    super.dispose();
  }
}
