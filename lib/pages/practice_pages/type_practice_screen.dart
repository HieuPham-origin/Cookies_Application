import 'dart:developer';

import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypePracticeScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String topicId;
  const TypePracticeScreen(
      {super.key, required this.data, required this.topicId});

  @override
  State<TypePracticeScreen> createState() => _TypePracticeScreenState();
}

class _TypePracticeScreenState extends State<TypePracticeScreen> {
  TopicService topicService = TopicService();
  List<Word> words = [];

  @override
  void initState() {
    fetchWord();
    super.initState();
  }

  void fetchWord() async {
    words = await topicService.getWordsForTopic(widget.topicId);
    log(words.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("${words[0].word}"),
    );
  }
}
