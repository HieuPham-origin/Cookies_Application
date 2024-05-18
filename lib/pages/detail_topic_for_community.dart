import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/practice_option.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/material.dart';

class DetailTopicCommunity extends StatefulWidget {
  final TopicCommunityCard topicCommunityCard;
  final Map<String, dynamic>? data;
  final String? communityId;
  DetailTopicCommunity(
      {Key? key,
      required this.topicCommunityCard,
      required this.data,
      this.communityId})
      : super(key: key);

  @override
  State<DetailTopicCommunity> createState() => _DetailTopicCommunityState();
}

class _DetailTopicCommunityState extends State<DetailTopicCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.arrow_back_ios),
                Text(
                  "Quay lại",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          centerTitle: true,
          title: Text(
            widget.topicCommunityCard.topicName,
          ),
        ),
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 40,
                width: Dimensions.width(
                    context, MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      AppColors.cookie,
                      Color.fromARGB(204, 185, 155, 107),
                    ])),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(200, 40),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    showPracticeptionModalBottomSheet(
                      context,
                      widget.topicCommunityCard.topicId!,
                      widget.data!,
                      type: 1,
                      communityId: widget.communityId,
                    );
                  },
                  child: const Text("Luyện tập"),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('topics')
                    .doc(widget.topicCommunityCard.topicId)
                    .collection('words')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List words = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: // Add this line to fix the error: A RenderFlex overflowed by Infinity pixels on the bottom.
                        const NeverScrollableScrollPhysics(), // Add this line to fix the error: A RenderFlex overflowed by Infinity pixels on the bottom.
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      return VocabularyCard(
                        word: words[index]['word'],
                        phonetics: words[index]['phonetic'] != ""
                            ? words[index]['phonetic']
                            : "/transcription/",
                        definition: words[index]['definition'],
                        wordForm: words[index]['wordForm'],
                        date: words[index]['date'],
                        isFav: words[index]['isFav'],
                        topicId: words[index]['topicId'],
                        type: 2,
                        onSpeakerPressed: () async {
                          await audioPlayer.stop();
                          await audioPlayer
                              .play(UrlSource(words[index]['audio']));
                        },
                        onTap: () {
                          showDetailVocabModalBottomSheet(
                              context,
                              widget.topicCommunityCard.topicId!,
                              words[index].id,
                              words[index]['word'],
                              words[index]['phonetic'],
                              words[index]['date'],
                              words[index]['definition'],
                              words[index]['image'],
                              words[index]['audio'],
                              words[index]['example'],
                              words[index]['wordForm'],
                              type: 1);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }
}
