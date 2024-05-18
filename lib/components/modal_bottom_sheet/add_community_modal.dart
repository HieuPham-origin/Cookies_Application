import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/models/community.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/constants.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

void showPostTopicModalBottomSheet(BuildContext context, String avatarUrl) {
  TextEditingController communityController = TextEditingController();
  TopicService topicService = TopicService();
  CommunityService communityService = CommunityService();
  bool isLoading = false;
  User user = FirebaseAuth.instance.currentUser!;
  String userId = user.uid;
  String displayName = user.displayName ?? 'cookieuser';
  List<Topic> listTopic = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    backgroundColor: const Color(0xfffefffe),
    builder: (context) => StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.header_background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: !isLoading
                        ? () async {
                            // Remove focus from any text fields to hide the keyboard
                            FocusScope.of(context).unfocus();

                            // Wait for a short duration to ensure the keyboard dismiss animation can complete
                            await Future.delayed(
                                const Duration(milliseconds: 200));

                            // Then, navigate back to the previous screen
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.cookie,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: Text(
                      // type == 1 ? "Tạo Topic" : "Sửa Topic",
                      "Bài mới",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.cookie,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        if (communityController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            // List<Map<String, dynamic>> topicsAsJson = listTopic
                            //     .map((topic) => topic.toJson())
                            //     .toList();
                            // await communityService.addCommunity(
                            //     userId,
                            //     displayName,
                            //     communityController.text,
                            //     DateTime.now().toString(),
                            //     0,
                            //     0,
                            //     topicsAsJson);

                            await communityService.addCommunity(
                                userId,
                                displayName,
                                communityController.text,
                                DateTime.now().toString(),
                                0,
                                0,
                                listTopic
                                    .map((topic) => topic.topicId!)
                                    .toList());

                            AppConstants.communities.add(Community(
                              userId: userId,
                              avatar: avatarUrl,
                              displayName: displayName,
                              content: communityController.text,
                              time: DateTime.now().toString(),
                              numOfLove: 0,
                              numOfComment: 0,
                              topicCommunityCard: listTopic
                                  .map<TopicCommunityCard>(
                                      (topic) => TopicCommunityCard(
                                            topicName: topic.topicName,
                                            numOfVocab: 10,
                                            color: topic.color,
                                          ))
                                  .toList(),
                            ));

                            Navigator.of(context).pop();
                          } catch (e) {
                            log(e.toString());
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: Dimensions.width(context,
                            40), // Adjust width according to your needs
                        height: 24, // Adjust height according to your needs
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Visibility(
                              visible: isLoading,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.cookie),
                              ),
                            ),
                            Visibility(
                              visible: !isLoading,
                              child: Text(
                                "Tiếp",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cookie,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: Dimensions.width(context, 42),
                          height: Dimensions.height(context, 42),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50), // This applies to the CachedNetworkImage

                            child: CachedNetworkImage(
                              imageUrl: avatarUrl != ""
                                  ? avatarUrl
                                  : "https://cdn.discordapp.com/attachments/1049968383082373191/1239879020414238844/logo.png?ex=664486d2&is=66433552&hm=64d4af042d201ef1982c7b048c362dcc2b68863cb21699556e21c13b27696415&",
                              placeholder: (context, url) => SizedBox(
                                width:
                                    20, // Adjust the width as per your requirement
                                height:
                                    20, // Adjust the height as per your requirement
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.cookie,
                                    strokeWidth:
                                        2, // Adjust the strokeWidth as per your requirement
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width(context, 10),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey_heavy,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                maxLines: null,
                                controller: communityController,
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: Dimensions.fontSize(context, 18),
                                    color: AppColors.grey_heavy,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Có gì mới?...",
                                  hintStyle: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey_light,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                  border: InputBorder.none,
                                  counterText: "",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: AppColors.grey_light,
                    thickness: 0.3,
                  ),
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: topicService.getTopicsByUserId(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List topics = snapshot.data!.docs;

                      return ListView.builder(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          shrinkWrap: true,
                          itemCount: topics.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot document = topics[index];
                            String docID = document.id;

                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            // Topic's attributes
                            String topicTitle = data['topicName'];
                            String color = data['color'];
                            return FutureBuilder<int>(
                                future: topicService.countWordsInTopic(docID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  int numOfVocabInTopicLibrary =
                                      snapshot.data ?? 0;

                                  return TopicCard(
                                    topicId: docID,
                                    topicName: topicTitle,
                                    numOfVocab: numOfVocabInTopicLibrary,
                                    color: color,
                                    listTopic: listTopic,
                                  );
                                });
                          });
                    } else {
                      return Center(child: Text("No Topics Found"));
                    }
                  }),
            ),
          ],
        ),
      );
    }),
  );
}
