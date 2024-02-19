// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/components/add_button.dart';
import 'package:cookie_app/components/topic_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Thư viện",
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB99B6B),
                ))),
          ),
          AddButton(
              onPressed: () {},
              title: "Topics",
              icon: CupertinoIcons.add_circled_solid),
          TopicItem(topicName: "Family Topic", numOfVocab: 10)
        ],
      ),
    );
  }
}
