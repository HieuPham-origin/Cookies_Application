// ignore_for_file: prefer_const_constructors
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/title_widget.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final emailController = TextEditingController();

  void _showModalBottomSheet(BuildContext context) {
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
                              icon: Icon(Icons.close,
                                  size: 28), // Your desired icon
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
                          style: GoogleFonts.inter(),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen),
                            ),
                            label: Text("Tên Topic"),
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
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
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
}
