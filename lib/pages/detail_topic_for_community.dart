import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/modal_bottom_sheet/detail_vocab_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/practice_option.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/components/vocabulary_card.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/pages/ranking_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toasty_box/toast_service.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                //bottom sheet
                if (widget.communityId != null) {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child:
                              RankingPage(communityId: widget.communityId!)));
                } else {
                  ToastService.showWarningToast(
                    context,
                    message: "Vui lòng reload trang cộng đồng để xem xếp hạng",
                  );
                }
              },
              child: Text(
                "Xếp hạng",
                style: TextStyle(
                  color: AppColors.cookie,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 10)
          ],
          centerTitle: true,
          title: Text(
            widget.topicCommunityCard.topicName,
          ),
        ),
        floatingActionButton: Container(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () async {
              QuickAlert.show(
                  context: context,
                  title: "Lưu topic",
                  text: "Bạn có muốn lưu topic này không?",
                  type: QuickAlertType.confirm,
                  showCancelBtn: true,
                  confirmBtnText: "Có",
                  cancelBtnText: "Không",
                  confirmBtnColor: AppColors.green,
                  onCancelBtnTap: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  onConfirmBtnTap: () async {
                    var newTopic = {
                      'topicName': widget.topicCommunityCard.topicName,
                      'isPublic': false,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'userEmail': FirebaseAuth.instance.currentUser!.email!,
                      'color': widget.topicCommunityCard
                          .color, // Set the default or your desired color
                    };
                    DocumentReference topicRef =
                        await _firestore.collection('topics').add(newTopic);

                    // Get all words of the topic
                    var words = await _firestore
                        .collection('topics')
                        .doc(widget.topicCommunityCard.topicId)
                        .collection('words')
                        .get();

                    // Add all words to the new topic
                    for (var word in words.docs) {
                      await _firestore
                          .collection('topics')
                          .doc(topicRef.id)
                          .collection('words')
                          .add({
                        'word': word['word'],
                        'phonetic': word['phonetic'],
                        'definition': word['definition'],
                        'image': word['image'],
                        'audio': word['audio'],
                        'example': word['example'],
                        'wordForm': word['wordForm'],
                        'isFav': word['isFav'],
                        'date': word['date'],
                        'userId': FirebaseAuth.instance.currentUser!.uid,
                        'topicId': topicRef.id,
                        'status': 0,
                      });
                    }
                  });
            },
            child: const Icon(Icons.download),
            backgroundColor: AppColors.black_opacity,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
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
                    if (widget.communityId != null) {
                      showPracticeptionModalBottomSheet(
                        context,
                        widget.topicCommunityCard.topicId!,
                        widget.data!,
                        type: 1,
                        communityId: widget.communityId,
                      );
                    } else {
                      ToastService.showWarningToast(
                        context,
                        message: "Vui lòng reload trang cộng đồng để tham gia",
                      );
                    }
                  },
                  child: const Text("Thi ngay"),
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
                  if (words.isEmpty) {
                    return const Center(
                      child: Text("Chưa có từ vựng nào"),
                    );
                  }

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
                        status: words[index]['status'],
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
