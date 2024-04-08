import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteVocabPage extends StatefulWidget {
  const FavoriteVocabPage({super.key});

  @override
  State<FavoriteVocabPage> createState() => _FavoriteVocabPageState();
}

WordService wordService = WordService();
TopicService topicService = TopicService();
final user = FirebaseAuth.instance.currentUser!;
List<String> topicId = [];
List<Word> words = [];

class _FavoriteVocabPageState extends State<FavoriteVocabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    words = [];
    List<Word> combinedWords = [];

    topicService.getTopicIdList(user.uid).then((value) {
      setState(() {
        topicId = value;
      });

      topicService.getAllFavoriteWords(topicId).then((value) {
        combinedWords.addAll(value);

        wordService.getFavoriteWordsByUserId(user.uid).listen((event) {
          combinedWords
              .addAll(event.docs.map((e) => Word.fromSnapshot(e)).toList());

          setState(() {
            words = combinedWords;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Từ yêu thích"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: words.isEmpty
          ? const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.background,
                  strokeCap: StrokeCap.round,
                  color: AppColors.cookie,
                ),
              ),
            )
          : Container(
              color: AppColors.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: StreamBuilder(
                    stream: topicService.convertListToStream(words),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Word> words = snapshot.data!;

                        return ListView.builder(
                          itemCount: words.length,
                          itemBuilder: (context, index) {
                            return VocabularyCard(
                              word: words[index].word,
                              definition: words[index].definition,
                              phonetics: words[index].phonetic,
                              date: words[index].date,
                              wordForm: words[index].wordForm,
                              isFav: words[index].isFav,
                              topicId: words[index].topicId,
                              type: 1,
                              onFavoritePressed: (bool isFav) async {
                                await topicService
                                    .updateFavoriteWordForTopicWithoutWordId(
                                  words[index].topicId,
                                  isFav,
                                );
                              },
                              onTap: () {
                                // showDetailVocabModalBottomSheet(
                                //   context,
                                //   words[index].topicId,

                                // );
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator(); // Or any loading indicator
                      }
                    },
                  )),
                ],
              ),
            ),
    );
  }
}
