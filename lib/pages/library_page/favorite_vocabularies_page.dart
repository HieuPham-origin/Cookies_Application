import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

WordService wordService = WordService();
TopicService topicService = TopicService();
final user = FirebaseAuth.instance.currentUser!;
List<DocumentSnapshot>? _favoriteWords;

class FavoriteVocabPage extends StatefulWidget {
  const FavoriteVocabPage({super.key});

  @override
  State<FavoriteVocabPage> createState() => _FavoriteVocabPageState();
}

class _FavoriteVocabPageState extends State<FavoriteVocabPage> {
  void _getFavoriteWords() async {
    final fetchedWords = <DocumentSnapshot>[];
    await wordService.getFavoriteWordsByUserId(user.uid).forEach((snapshot) {
      fetchedWords.addAll(snapshot.docs);
    });
    setState(() {
      _favoriteWords = fetchedWords;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFavoriteWords();
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
      body: Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: StreamBuilder<QuerySnapshot>(
              stream: wordService.getFavoriteWordsByUserId(user.uid),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.hasData) {
                  List words = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = words[index];
                      String wordId = document.id;
                      String word = document['word'];
                      String phonetic = document['phonetic'];
                      String date = document['date'];
                      String definition = document['definition'];
                      String image = document['image'];
                      String audio = document['audio'];
                      String example = document['example'];
                      String wordForm = document['wordForm'];

                      return VocabularyCard(
                        word: words[index]['word'],
                        definition: words[index]['definition'],
                        phonetics: words[index]['phonetic'],
                        date: words[index]['date'],
                        wordForm: words[index]['wordForm'],
                        isFav: words[index]['isFav'],
                        topicId: words[index]['topicId'],
                        status: words[index]['status'],
                        onFavoritePressed: (bool isFav) {
                          if (words[index]['topicId'] == "") {
                            wordService.updateFavorite(wordId, isFav);
                          } else {
                            topicService.updateFavoriteWordForTopic(
                                words[index]['topicId'], wordId, isFav);
                          }

                          wordService.removeFavoriteWord(wordId);
                          return Future(() => null);
                        },
                        onTap: () {
                          showDetailVocabModalBottomSheet(
                            context,
                            words[index]['topicId'],
                            wordId,
                            word,
                            phonetic,
                            date,
                            definition,
                            image,
                            audio,
                            example,
                            wordForm,
                            user: user,
                            topicService: topicService,
                          );
                        },
                        type: 1,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(); // Or any loading indicator
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _favoriteWords = null;
    super.dispose();
  }
}
