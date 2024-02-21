// ignore_for_file: prefer_const_constructors

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.greenAccent,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(child: Icon(Icons.topic), label: "Thêm topic"),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                TopicCard(
                  onTap: () {},
                  topicName: "Family Topic",
                  numOfVocab: 10,
                ),
                TopicCard(
                  onTap: () {},
                  topicName: "Family Topic",
                  numOfVocab: 10,
                ),
                TopicCard(
                  onTap: () {},
                  topicName: "Family Topic",
                  numOfVocab: 10,
                ),
              ],
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
            child: ListView(
              shrinkWrap: true,
              children: [
                VocabularyCard(
                  onSpeakerPressed: () {},
                  onFavoritePressed: () {},
                  onSavePressed: () {},
                  onSharePressed: () {},
                  word: "keyboard",
                  phonetics: "phonetics",
                  definition: "bàn phím",
                  wordForm: "noun",
                  date: "6-9-2069",
                ),
                VocabularyCard(
                  onSpeakerPressed: () {},
                  onFavoritePressed: () {},
                  onSavePressed: () {},
                  onSharePressed: () {},
                  word: "keyboard",
                  phonetics: "phonetics",
                  definition: "bàn phím",
                  wordForm: "noun",
                  date: "6-9-2069",
                ),
                VocabularyCard(
                  onSpeakerPressed: () {},
                  onFavoritePressed: () {},
                  onSavePressed: () {},
                  onSharePressed: () {},
                  word: "keyboard",
                  phonetics: "phonetics",
                  definition: "bàn phím",
                  wordForm: "noun",
                  date: "6-9-2069",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
