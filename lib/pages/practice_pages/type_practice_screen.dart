import 'dart:async';
import 'dart:developer';

import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:pinput/pinput.dart';

class TypePracticeScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String topicId;
  final int? type;
  final String? communityId;

  const TypePracticeScreen(
      {super.key,
      required this.data,
      required this.topicId,
      this.type,
      this.communityId});

  @override
  State<TypePracticeScreen> createState() => _TypePracticeScreenState();
}

class _TypePracticeScreenState extends State<TypePracticeScreen> {
  TopicService topicService = TopicService();
  List<Word> words = [];
  bool isLoading = true;
  PageController _pageController = PageController();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  int currentSegment = 0;
  String input = '';
  bool isCorrect = false;
  final Color textColor = AppColors.coffee;
  int point = 0;
  bool isCompleted = false;
  bool isChecked = false;
  int currentQuestion = 0;
  int timeTaken = 0;
  Timer? timerTotal;
  CommunityService communityService = CommunityService();

  @override
  void initState() {
    fetchWord();
    totalTime();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
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

  Future<void> fetchWord() async {
    words = await topicService.getWordsForTopic(widget.topicId);
    setState(
      () {
        isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 34,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: isChecked
            ? isCorrect
                ? AppColors.coffee
                : Colors.red
            : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: Colors.grey, width: 1), // Only bottom border
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: words.length,
              onPageChanged: (value) {},
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      timeTaken.toString(),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "${words[index].definition}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 32, 8, 8),
                          child: Text(
                            "Trả lời:",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                      length: words[index].word.replaceAll(' ', '').length,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        if (pin == words[index].word.replaceAll(' ', '')) {
                          isCorrect = true;
                        } else {
                          isCorrect = false;
                        }
                        setState(() {
                          isCompleted = true;
                        });
                      },
                      onChanged: (value) {
                        isCorrect = true;
                        setState(() {
                          isCompleted = false;
                        });
                      },
                      keyboardType: TextInputType.text,
                      defaultPinTheme: defaultPinTheme,
                      autofocus: true,
                      cursor: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.coffee,
                                width: 2), // Only bottom border
                          ),
                        ),
                      ),
                      errorText: "Đáp án không chính xác",
                    ),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB99B6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          elevation: 4,
                          shadowColor: Colors.black,
                        ),
                        onPressed: isCompleted
                            ? () {
                                if (isChecked) {
                                  if (currentQuestion < words.length - 1) {
                                    pinController.clear();
                                    setState(() {
                                      isChecked = false;
                                    });
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );

                                    currentQuestion++;
                                  } else {
                                    timerTotal!.cancel();
                                    Dialogs.materialDialog(
                                      color: Colors.white,
                                      msg:
                                          'Bạn đã làm đúng $point/${words.length} câu và điểm của bạn là ${((point / timeTaken) * 100).round()}',
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
                                              communityService
                                                  .comparePointAndAddNewDocument(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                widget.topicId,
                                                0,
                                                ((point / timeTaken) * 100)
                                                    .round(),
                                                widget.communityId!,
                                              );
                                            }
                                            int count = 0;
                                            Navigator.of(context)
                                                .popUntil((_) => count++ >= 2);
                                          },
                                          text: 'Hoàn thành',
                                          iconData: Icons.done,
                                          color: Colors.blue,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          text: 'Làm lại',
                                          iconData: Icons.redo,
                                          color: Colors.blue,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ],
                                    );
                                  }
                                } else {
                                  if (isCorrect) {
                                    setState(() {
                                      point++;
                                    });
                                  }
                                  setState(
                                    () {
                                      isChecked = true;
                                    },
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          isChecked ? "Tiếp tục" : "Kiểm tra",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    isChecked && !isCorrect
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Đáp án: ${words[index].word}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                );
              },
            ),
    );
  }
}
