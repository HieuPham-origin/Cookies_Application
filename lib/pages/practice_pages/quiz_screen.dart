// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:async';
import 'dart:developer';

import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/QuizService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cookie_app/services/TopicService.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:wheel_picker/wheel_picker.dart';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String topicId;
  final int? type;
  final String? communityId;
  const QuizScreen({
    Key? key,
    required this.data,
    required this.topicId,
    this.type,
    this.communityId,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  //Service
  TopicService topicService = TopicService();
  QuizService quizService = QuizService();
  CommunityService communityService = CommunityService();

  //Variables
  int questionTimerSeconds = 15;
  bool isLocked = true;
  List<Word> words = [];
  var questions;
  Timer? _timer;
  Timer? timerTotal;
  int point = 0;
  List optionsLetters = ["A.", "B.", "C.", "D."];
  int currentQuiz = 1;
  int timeChoose = 15;
  int timeTaken = 0;
  String language = "Tiếng Anh";
  bool isSettingApply = false;

  //Controllers
  PageController _pageController = PageController();
  TextEditingController _setTimeController = TextEditingController();

  //Functions
  Future<List<Word>> fetchWords() async {
    words = await topicService.getWordsForTopic(widget.topicId);
    return words;
  }

  void startTimerOnQuestions() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (questionTimerSeconds > 0) {
            questionTimerSeconds--;
          } else {
            _timer?.cancel();
            timerTotal?.cancel();
            restartTimer(timeChoose);
          }
        });
      }
    });
  }

  void totalTime() {
    timerTotal = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeTaken++;
        });
      }
    });
  }

  void restartQuiz() {
    setState(() {
      point = 0;
      currentQuiz = 1;
      timeTaken = 0;
    });
    if (language == "Tiếng Việt") {
      questions = quizService.generateQuizQuestions(words, true);
    } else if (language == "Tiếng Anh") {
      questions = quizService.generateQuizQuestions(words, false);
    }
    _pageController.jumpToPage(0);
    startTimerOnQuestions();
    if (widget.type != 1) {
      totalTime();
    }
  }

  void restartTimer(int time) {
    setState(
      () {
        isLocked = true;
        questionTimerSeconds = time;
        if (currentQuiz < words.length) {
          currentQuiz++;

          startTimerOnQuestions();
        }
      },
    );
  }

  void quizSettingBottomSheet(BuildContext context) {
    final secondsWheel = WheelPickerController(itemCount: 31);
    const textStyle = TextStyle(fontSize: 20.0, height: 1.5);
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        _timer?.cancel();

        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SizedBox(
              height: screenSize.height * 0.5,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Dimensions.height(context, 10),
                    ),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Đặt thời gian",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        WheelPicker(
                          builder: (context, index) =>
                              Text("${index + 10}", style: textStyle),
                          controller: secondsWheel,
                          selectedIndexColor: AppColors.cookie,
                          onIndexChanged: (index) {
                            timeChoose = index + 10;
                            questionTimerSeconds = index + 10;
                          },
                          style: WheelPickerStyle(
                            itemExtent: textStyle.fontSize! *
                                textStyle.height!, // Text height
                            squeeze: 1.25,
                            diameterRatio: .6,
                            surroundingOpacity: .25,
                            magnification: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Loại câu hỏi",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        DropdownButton(
                          value: language,
                          items: <String>['Tiếng Anh', 'Tiếng Việt']
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            //change language
                            setState(() {
                              language = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.height(context, 70),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.coffee),
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.sizeOf(context).width * 0.80, 40),
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        isSettingApply = true;
                      },
                      child: Text(
                        "Áp dụng",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (isSettingApply) {
        restartQuiz();
      } else {
        startTimerOnQuestions();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == 1) {
      totalTime();
    }
    fetchWords().then((fetchedWords) {
      setState(() {
        words = fetchedWords;
        questions = quizService.generateQuizQuestions(words, false);
      });
    });
    startTimerOnQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.data['topicName']} ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                widget.type == 1
                    ? SizedBox.shrink()
                    : IconButton(
                        onPressed: () {
                          _timer?.cancel();
                          quizSettingBottomSheet(context);
                        },
                        icon: Icon(Icons.settings),
                      )
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
                        minHeight: 15,
                        value: (questionTimerSeconds / timeChoose),
                        backgroundColor: Colors.blue.shade100,
                        color: Colors.blueGrey,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.coffee),
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
                      padding: EdgeInsets.all(0.0),
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
                                onPageChanged: (value) {
                                  // setState(() {
                                  //   isLocked = true;
                                  //   questionTimerSeconds = 20;
                                  // });
                                },
                                itemBuilder: (context, index) {
                                  var currentQuestion = questions[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
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
                                              var color = Colors.grey.shade300;
                                              var iconColor =
                                                  Colors.grey.shade300;
                                              IconData icon = Icons.abc;
                                              final letters =
                                                  optionsLetters[optionIndex];
                                              final option = currentQuestion
                                                  .options[optionIndex];
                                              final userAnswer =
                                                  questions[index]
                                                      .options[optionIndex];

                                              final correctAnswer =
                                                  questions[index]
                                                      .correctAnswer;

                                              if (!isLocked) {
                                                if (option == correctAnswer) {
                                                  color = Colors.green.shade700;
                                                  icon = Icons.check_circle;
                                                  iconColor =
                                                      Colors.green.shade700;
                                                } else {
                                                  color = Colors.red.shade700;
                                                  icon = Icons.cancel;
                                                  iconColor = Colors.red;
                                                }
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      isLocked = false;
                                                    },
                                                  );
                                                  if (userAnswer ==
                                                      correctAnswer) {
                                                    point++;
                                                  }
                                                  _timer!.cancel();
                                                },
                                                child: Container(
                                                  height: 45,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: color),
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
                                                      !isLocked
                                                          ? Icon(icon,
                                                              color: iconColor)
                                                          : SizedBox.shrink(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        isLocked
                                            ? const SizedBox.shrink()
                                            : buildElevatedButton(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.coffee),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.sizeOf(context).width * 0.80, 40),
        ),
        elevation: MaterialStateProperty.all(4),
      ),
      onPressed: () {
        if (currentQuiz < words.length) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          if (widget.type == 1) {
            timerTotal!.cancel();
          }
          Dialogs.materialDialog(
            color: Colors.white,
            msg: 'Bạn đã làm đúng $point/${words.length} câu',
            title: 'Chúc mừng',
            lottieBuilder: Lottie.asset(
              repeat: false,
              'assets/card_finish.json',
              fit: BoxFit.contain,
            ),
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  if (widget.type == 1) {
                    communityService.comparePointAndAddNewDocument(
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.topicId,
                      ((point / timeTaken) * 100).round(),
                      0,
                      widget.communityId!,
                    );
                  }
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                text: 'Hoàn thành',
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              IconsButton(
                onPressed: () {
                  Navigator.pop(context);
                  restartQuiz();
                },
                text: 'Làm lại',
                iconData: Icons.redo,
                color: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ],
          );
        }
        restartTimer(timeChoose);
      },
      child: Text(
        currentQuiz < words.length ? "Tiếp tục" : "Hoàn thành",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    timerTotal!.cancel();
    super.dispose();
  }
}
