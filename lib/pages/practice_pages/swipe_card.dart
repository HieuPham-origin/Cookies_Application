// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, sort_child_properties_last
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/theme/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toasty_box/toast_service.dart';

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
  List<Word> words = [];
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Word>> fetchWords() async {
    words = await topicService.getWordsForTopic(widget.topidId);
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                leading: Text(
                  "1/10",
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
                percent: 0.1,
                animation: true,
                animationDuration: 1000,
                backgroundColor: Colors.grey,
                barRadius: Radius.circular(20),
                progressColor: Colors.lightGreen,
              ),
            ],
          ),
          FutureBuilder<List<Word>>(
            future: fetchWords(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
              }
              return Container(
                padding: EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: AppinioSwiper(
                  backgroundCardCount: 1,
                  cardCount: words.isEmpty ? 1 : words.length,
                  swipeOptions:
                      const SwipeOptions.only(left: true, right: true),
                  cardBuilder: (BuildContext context, int index) {
                    return words.isEmpty
                        ? Text("")
                        : FlipCard(
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
                                      words[index].word,
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      words[index].phonetic,
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
                                          UrlSource(words[index].audio),
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
                                      words[index].definition,
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
              );
            },
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
                      onPressed: () {},
                      icon: Icon(Icons.replay),
                      iconSize: 30,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.shuffle),
                      iconSize: 30,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.play_arrow),
                      iconSize: 30,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
