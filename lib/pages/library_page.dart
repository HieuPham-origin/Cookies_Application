// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/title_widget.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/model/topic.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toasty_box/toasty_box.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final topicController = TextEditingController();
  final topicService = TopicService();
  final user = FirebaseAuth.instance.currentUser!;
  bool _btnActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _showAddTopicModalBottomSheet(BuildContext context) {
    topicController.clear();
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
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
                                borderSide:
                                    BorderSide(color: Colors.lightGreen),
                              ),
                              label: Text("Tên Topic"),
                              floatingLabelStyle: TextStyle(
                                color: Colors.lightGreen,
                              )),
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
                            "Thêm",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void showTopicDetail(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            builder: (builder, scrollController) => SingleChildScrollView(
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
            ),
          )),
    );
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
            "Thư viện",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB99B6B),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.greenAccent,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.topic),
            label: "Thêm topic",
            onTap: () => _showAddTopicModalBottomSheet(context),
          ),
          SpeedDialChild(child: Icon(Icons.abc), label: "Thêm từ vựng"),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleWidget(
              title: "Topics",
            ),
            StreamBuilder<QuerySnapshot>(
              stream: topicService.getAllTopics(),
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
              height: 50,
            ),
            TitleWidget(
              title: "Từ vựng",
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return VocabularyCard(
                  onSpeakerPressed: () {},
                  onFavoritePressed: () {},
                  onSavePressed: () {},
                  onSharePressed: () {},
                  word: "keyboard",
                  phonetics: "phonetics",
                  definition: "bàn phím",
                  wordForm: "noun",
                  date: "6-9-2069",
                );
              },
            ),
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
