// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, sort_child_properties_last
import 'dart:developer';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class SwipeCard extends StatefulWidget {
  final String topidId;
  const SwipeCard({
    Key? key,
    required this.topidId,
  }) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  TopicService topicService = TopicService();
  WordService wordService = WordService();
  List<dynamic> words = [];

  final audioPlayer = AudioPlayer();
  int currentCard = 1;
  FlipCardController flipCardController = FlipCardController();
  AppinioSwiperController swiperController = AppinioSwiperController();
  bool isShuffled = false;
  bool isAutoplay = false;
  bool isFlipped = false;
  double swipeOpacity = 0.0;
  String swipeText = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Key swiperKey = ValueKey<int>(0);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      _shakeCard();
    });
    super.initState();
    fetchWords().then((fetchedWords) {
      setState(() {
        words = fetchedWords;
      });
    });
  }

  Future<List<dynamic>> fetchWords() async {
    QuerySnapshot snapshot = await _firestore
        .collection('topics')
        .doc(widget.topidId)
        .collection('words')
        .get();

    List<DocumentSnapshot> wordDocs = snapshot.docs;

    for (var i = 0; i < wordDocs.length; i++) {
      DocumentSnapshot wordSnapshot = wordDocs[i];
      Map<String, dynamic>? wordData =
          wordSnapshot.data() as Map<String, dynamic>?;
      if (wordData != null) {
        Word word = Word(
          word: wordData['word'],
          definition: wordData['definition'],
          phonetic: wordData['phonetic'],
          date: wordData['date'],
          image: wordData['image'],
          wordForm: wordData['wordForm'],
          example: wordData['example'],
          audio: wordData['audio'],
          isFav: wordData['isFav'],
          topicId: wordData['topicId'],
          status: wordData['status'],
          userId: wordData['userId'],
        );

        words.add({'word': word, 'id': wordSnapshot.id});
      } else {}
    }

    return words;
  }

  Future<void> updateWordStatus(String wordId, int status) async {
    await wordService.updateStatus(widget.topidId, wordId, status);
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        setState(
          () {
            currentCard = currentCard + 1;
          },
        );
        if (isFlipped) {
          flipCardController.toggleCardWithoutAnimation();
          isFlipped = false;
        }

        if (activity.direction.name == 'left') {
          String wordId = words[previousIndex]['id'];

          updateWordStatus(wordId, 1);
          ToastService.showToast(
            context,
            isClosable: true,
            backgroundColor: Colors.teal.shade500,
            shadowColor: Colors.teal.shade200,
            length: ToastLength.short,
            expandedHeight: 70,
            message: "Đang học từ ${words[previousIndex]['word'].word}",
            messageStyle: TextStyle(fontSize: 18),
            leading: const Icon(Icons.messenger),
            slideCurve: Curves.elasticInOut,
            positionCurve: Curves.bounceOut,
            dismissDirection: DismissDirection.none,
          );
        }

        if (activity.direction.name == 'right') {
          String wordId = words[previousIndex]['id'];

          updateWordStatus(wordId, 2);
          ToastService.showToast(
            context,
            isClosable: true,
            backgroundColor: AppColors.coffee,
            shadowColor: Colors.teal.shade200,
            length: ToastLength.short,
            expandedHeight: 70,
            message: "Đã thuộc từ ${words[previousIndex]['word'].word}",
            messageStyle: TextStyle(fontSize: 18, color: Colors.white),
            leading: const Icon(Icons.messenger),
            slideCurve: Curves.elasticInOut,
            positionCurve: Curves.bounceOut,
            dismissDirection: DismissDirection.none,
          );
        }

        break;
      case Unswipe():
        log('A ${activity.direction.name} swipe was undone.');
        log('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        log('A swipe was cancelled');
        break;
      case DrivenActivity():
        log('Driven Activity');
        break;
    }
  }

  void replayCard() {
    if (currentCard > 1) {
      setState(() {
        currentCard--;
      });
      swiperController.unswipe();
    }
  }

  void autoPlay() async {
    int index = currentCard - 1;
    setState(() {
      isAutoplay = !isAutoplay;
    });

    log(isAutoplay.toString());
    while (isAutoplay) {
      await audioPlayer.play(UrlSource(words[index]['word'].audio));

      await Future.delayed(Duration(seconds: 2));
      flipCardController.toggleCard();

      await Future.delayed(Duration(seconds: 2));

      swiperController.swipeRight();

      index++;
    }
  }

  void shuffleCard() {
    setState(() {
      words.shuffle();
      currentCard = 1;
      swiperKey = ValueKey<int>(DateTime.now().millisecondsSinceEpoch);
    });
  }

  Future<void> _shakeCard() async {
    const double distance = 30;
    await swiperController.animateTo(
      const Offset(-distance, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await swiperController.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await swiperController.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double progressPercentage =
        (currentCard / (words.isEmpty ? 100 : words.length));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  leading: Text(
                    "${currentCard > words.length ? words.length : currentCard}/${words.length}",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: 28,
                    ),
                  ),
                  lineHeight: 6.0,
                  width: MediaQuery.of(context).size.width * 0.75,
                  percent: progressPercentage > 1 ? 1 : progressPercentage,
                  animateFromLastPercent: true,
                  animation: true,
                  animationDuration: 700,
                  backgroundColor: Colors.grey,
                  barRadius: Radius.circular(20),
                  progressColor: Colors.lightGreen,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              child: AppinioSwiper(
                key: swiperKey,
                onEnd: () {
                  Dialogs.bottomMaterialDialog(
                    msg: 'Bạn đã hoàn thành topic này',
                    title: 'Chúc mừng',
                    color: Colors.white,
                    lottieBuilder: Lottie.asset(
                      'assets/card_finish.json',
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () {
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        },
                        text: 'Hoàn tất ',
                        color: AppColors.coffee,
                        textStyle: TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ],
                  );
                },
                controller: swiperController,
                backgroundCardCount: 1,
                allowUnlimitedUnSwipe: true,
                cardCount: words.isEmpty ? 1 : words.length,
                onSwipeEnd: _swipeEnd,
                swipeOptions: const SwipeOptions.only(left: true, right: true),
                cardBuilder: (BuildContext context, int index) {
                  return words.isEmpty
                      ? Text("")
                      : FlipCard(
                          onFlipDone: (isFront) => {
                            if (isFront)
                              {isFlipped = true}
                            else
                              {isFlipped = false}
                          },
                          controller: flipCardController,
                          side: CardSide.FRONT,
                          speed: 350,
                          front: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            surfaceTintColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    words[index]['word'].word,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    words[index]['word'].phonetic,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await audioPlayer.play(
                                        UrlSource(words[index]['word'].audio),
                                      );
                                    },
                                    icon: Icon(Icons.volume_up),
                                    iconSize: 36,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          back: Card(
                            elevation: 4,
                            shadowColor: Colors.black,
                            surfaceTintColor: AppColors.coffee,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    words[index]['word'].definition,
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: Colors.white,
                          ),
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Card(
                elevation: 4,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: replayCard,
                        icon: Icon(Icons.replay),
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: shuffleCard,
                        icon: Icon(Icons.shuffle),
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: autoPlay,
                        icon: isAutoplay
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
