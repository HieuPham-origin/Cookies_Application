// ignore_for_file: prefer_const_constructors
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/title_widget.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/model/topic.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

  void _showModalBottomSheet(BuildContext context) {
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
                                    ToastService.showToast(context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.greenAccent,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Icon(Icons.topic),
            label: "Thêm topic",
            onTap: () => _showModalBottomSheet(context),
          ),
          SpeedDialChild(child: Icon(Icons.abc), label: "Thêm từ vựng"),
        ],
      ),
      backgroundColor: Color(0xFFF0F0F0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Thư viện từ vựng",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.coffee,
                ),
              ),
            ),
          ),
          TitleWidget(
            title: "Topics",
          ),
          Flexible(
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return TopicCard(
                  onTap: () {},
                  topicName: "Famimy",
                  numOfVocab: 10,
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TitleWidget(
            title: "Từ vựng",
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    topicController.dispose();
    super.dispose();
  }
}
