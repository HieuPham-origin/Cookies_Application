import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/pages/detail_topic_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toasty_box/toasty_box.dart';

void addWordToTopic(String topicId, String wordId, Word word) async {
  try {
    await topicService.addWordToTopic(topicId, wordId, word);
    await wordService.deleteWord(wordId);
  } catch (e) {
    print("failed" + e.toString());
    // Optionally, show an error toast or dialog
  }
}

void showVocabulariesModalBottomSheet(
    BuildContext context,
    String topicId,
    Function(int) setNumOfVocabInTopicFromLibrary,
    int numOfVocabInTopicFromLibrary,
    Function(int) setNumOfWord,
    int numOfVocab,
    void Function(int) setNumOfVocab
    // int numOfWord,
    ) {
  var screenSize = MediaQuery.of(context).size;

  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      isDismissible: false,
      context: context,
      builder: (context) => DraggableScrollableSheet(
            expand: false,
            shouldCloseOnMinExtent: true,
            initialChildSize: 0.95,
            builder: (BuildContext contextVocabulary,
                ScrollController scrollController) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(contextVocabulary).pop();
                          },
                          child: Text(
                            "Hủy",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.cookie,
                            ),
                          ),
                        ),
                        Text(
                          "Thêm vào Topic",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.cookie,
                          ),
                        ),
                        InkWell(
                          onTap: () async {},
                          child: Text("         "),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: wordService.getWordsByUserId(user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              List words = snapshot.data!.docs;

                              if (words.isEmpty) {
                                return Center(
                                    child: Column(
                                  children: [
                                    Container(
                                      height: screenSize.height * 0.18,
                                      width: screenSize.width * 0.3,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                            'assets/logo_icon_removebg.png'),
                                        fit: BoxFit.contain,
                                      )),
                                    ),
                                    Text("Không có từ vựng nào",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: AppColors.grey_light)),
                                    ElevatedButton(
                                      onPressed: () {
                                        // showAddVocabModalBottomSheet(
                                        //     context,
                                        //     wordController,
                                        //     definitionController,
                                        //     user,
                                        //     wordHintText,
                                        //     _image,
                                        //     wordForm, (int numOfVocab) {
                                        //   setState(() {
                                        //     this.numOfVocab = numOfVocab;
                                        //   });
                                        // }, numOfVocab);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: AppColors.creamy,
                                        foregroundColor: AppColors.cookie,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text("Tạo từ vựng đầu tiên"),
                                    ),
                                  ],
                                ));
                              }
                              words.sort((a, b) {
                                return b['date'].compareTo(a['date']);
                              });
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: words.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document = words[index];
                                    String wordId = document.id;
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;

                                    String word = data['word'];
                                    String definition = data['definition'];
                                    String phonetic = data['phonetic'];
                                    String date = data['date'];
                                    String image = data['image'];
                                    String wordForm = data['wordForm'];
                                    String example = data['example'];
                                    String audio = data['audio'];
                                    bool isFav = data['isFav'];
                                    int status = data['status'];
                                    String userId = data['userId'];

                                    return VocabularyCard(
                                      word: word,
                                      phonetics: phonetic != ""
                                          ? phonetic
                                          : "/transcription/",
                                      definition: definition,
                                      wordForm: wordForm,
                                      date: date,
                                      isFav: isFav,
                                      topicId: topicId,
                                      type: 2,
                                      onSpeakerPressed: () async {
                                        await audioPlayer.stop();
                                        await audioPlayer
                                            .play(UrlSource(audio));
                                      },
                                      onFavoritePressed: (bool isFav) async {
                                        await wordService.updateFavorite(
                                            wordId, isFav);
                                        return !isFav;
                                      },
                                      onTap: () => {
                                        addWordToTopic(
                                            topicId,
                                            wordId,
                                            Word(
                                              word: word,
                                              definition: definition,
                                              phonetic: phonetic,
                                              date: date,
                                              image: image,
                                              wordForm: wordForm,
                                              example: example,
                                              audio: audio,
                                              isFav: isFav,
                                              topicId: topicId,
                                              status: status,
                                              userId: userId,
                                            )),
                                        setNumOfWord(numOfWord + 1),
                                        setNumOfVocabInTopicFromLibrary(
                                            numOfVocabInTopicFromLibrary + 1),
                                        setNumOfVocab(numOfVocab - 1),
                                        Navigator.of(contextVocabulary).pop(),
                                      },
                                    );
                                  });
                            } else {
                              return Center(child: Text("No Words Found"));
                            }
                          }),
                    ),
                  ),
                ],
              );
            },
          ));
}
