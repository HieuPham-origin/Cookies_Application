import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/services/FolderService.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void showDetailFolderModalBottomSheet(
  BuildContext context,
  String folderName,
  String folderId,
  int numOfVocabInTopic,
  int numOfVocab,
  int numOfTopic,
  Function(int) setNumOfTopic,
  Function(int) setNumOfVocab,
  Function(int) setNumOfVocabInTopicFromLibrary,
) {
  TopicService topicService = TopicService();
  FolderService folderService = FolderService();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        shouldCloseOnMinExtent: true,
        initialChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
              builder: (context, void Function(void Function()) setState) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfffcfafb),
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
                          "Hủy      ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.icon_grey,
                          ),
                        ),
                      ),
                      Text(
                        folderName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.icon_grey,
                        ),
                      ),
                      InkWell(
                        onTap: () async {},
                        child: Text(
                          "Tạo mới",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.icon_grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: folderService.getTopicsInFolder(folderId),
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
                                      int numOfVocabInTopicInFolder =
                                          snapshot.data ?? 0;
                                      return TopicCard(
                                        onTap: () async => {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: DetailTopic(
                                                    data: data,
                                                    docID: docID,
                                                    numOfVocabInTopic:
                                                        numOfVocabInTopic,
                                                    numOfVocabInTopicInFolder:
                                                        numOfVocabInTopicInFolder,
                                                    numOfVocab: numOfVocab,
                                                    numOfTopic: numOfTopic,
                                                    setNumOfTopic:
                                                        setNumOfTopic,
                                                    setNumOfVocabInTopicFromLibrary:
                                                        setNumOfVocabInTopicFromLibrary,
                                                    setNumOfVocab:
                                                        setNumOfVocab,
                                                    setNumOfTopicInFolder:
                                                        (int value) => {
                                                      setState(() {
                                                        numOfVocabInTopicInFolder =
                                                            value;
                                                      })
                                                    },
                                                  ))),
                                        },
                                        topicName: topicTitle,
                                        numOfVocab: numOfVocabInTopicInFolder,
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
                ),
              ],
            );
          });
        },
      );
    },
  );
}
