import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:toasty_box/toasty_box.dart';

void addWordToTopic(void Function() popCallback, String topicId, String wordId,
    Word word) async {
  try {
    await topicService.addWordToTopic(topicId, wordId, word);
    await wordService.deleteWord(wordId);
    popCallback();
  } catch (e) {
    ToastService.showErrorToast('Failed to add word to topic' as BuildContext);
    // Optionally, show an error toast or dialog
  }
}

void showTopicsModalBottomSheet(
  BuildContext context,
  String wordId,
  String word,
  String definition,
  String phonetic,
  String date,
  String image,
  String wordForm,
  String example,
  String audio,
  bool isFav,
  String topicId,
  int status,
  String userId,
  Function(int) setNumOfVocabInTopic,
  int numOfVocabInTopic,
  Function(int) setNumOfVocab,
  int numOfVocab,
) {
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
            builder: (BuildContext context, ScrollController scrollController) {
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
                            Navigator.of(context).pop();
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
                          child: Text(
                            "Tạo mới",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.cookie,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: topicService.getTopicsByUserId(userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List topics = snapshot.data!.docs;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: topics.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = topics[index];
                                String docID = document.id;
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                //Topic's attributes
                                String topicTitle = data['topicName'];
                                String color = data['color'];

                                return FutureBuilder(
                                  future: topicService.countWordsInTopic(docID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      int numOfVocabInTopicOption =
                                          snapshot.data ?? 0;
                                      return TopicCard(
                                        onTap: () => {
                                          addWordToTopic(() {
                                            Navigator.of(context).pop();
                                          },
                                              docID,
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
                                                topicId: docID,
                                                status: status,
                                                userId: userId,
                                              )),
                                          setNumOfVocabInTopic(
                                              numOfVocabInTopic + 1),
                                          setNumOfVocab(numOfVocab - 1),
                                        },
                                        topicName: topicTitle,
                                        numOfVocab: numOfVocabInTopicOption,
                                        color: color,
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          } else {
                            return Center(child: Text("No Topics Found"));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ));
}
