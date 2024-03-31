// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/QuizService.dart';
import 'package:flutter/material.dart';

import 'package:cookie_app/services/TopicService.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String topicId;
  const QuizScreen({
    Key? key,
    required this.data,
    required this.topicId,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionTimerSeconds = 20;
  bool isLocked = true;
  TopicService topicService = TopicService();
  QuizService quizService = QuizService();
  List<Word> words = [];
  Timer? _timer;

  PageController _pageController = PageController();
  List optionsLetters = ["A.", "B.", "C.", "D."];

  int currentQuiz = 1;
  Future<List<Word>> fetchWords() async {
    words = await topicService.getWordsForTopic(widget.topicId);
    return words;
  }

  @override
  void initState() {
    super.initState();
    fetchWords().then((fetchedWords) {
      setState(() {
        words = fetchedWords;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var questions = quizService.generateQuizQuestions(words);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data['topicName']}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                        weight: 10,
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          minHeight: 20,
                          value: 1 - (100 / 20),
                          backgroundColor: Colors.blue.shade100,
                          color: Colors.blueGrey,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.24),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: words.isEmpty
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$currentQuiz/${words.length}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade500),
                              ),
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: questions.length,
                                  onPageChanged: (value) {},
                                  itemBuilder: (context, index) {
                                    var currentQuestion = questions[index];

                                    return Column(
                                      children: [
                                        Text(
                                          "${currentQuestion.question}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontSize: 18,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: 4,
                                            itemBuilder:
                                                (context, optionIndex) {
                                              final letters =
                                                  optionsLetters[optionIndex];
                                              final option = currentQuestion
                                                  .options[optionIndex];

                                              return InkWell(
                                                onTap: () {
                                                  log("clicked" +
                                                      index.toString());
                                                },
                                                child: Container(
                                                  height: 45,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade200),
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${letters + option}",
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        isLocked
                                            ? buildElevatedButton()
                                            : const SizedBox.shrink(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              )
            ]),
      ),
    );
  }

  ElevatedButton buildElevatedButton() {
    log("built...");
    return ElevatedButton(
      onPressed: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      },
      child: Text("Tiếp tục"),
    );
  }
}
