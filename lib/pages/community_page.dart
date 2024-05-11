import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/community_card.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_community_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_wallpost.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/constants.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

final GlobalKey<WallPostState> bottomSheetKey = GlobalKey<WallPostState>();

class _CommunityPageState extends State<CommunityPage> {
  CommunityService communityService = CommunityService();
  UserService userService = UserService(user);

  @override
  void initState() {
    // TODO: implement in itState
    super.initState();
    _precacheImages();
  }

  Future<List<String>> fetchImageUrls() async {
    List<String> imageUrls = [];
    await communityService.getAllCommunitiesToLoadImage().then((value) {
      for (var element in value.docs) {
        imageUrls.add(element['image']);
      }
    });
    return imageUrls;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _precacheImages() async {
    List<String> imageUrls = await fetchImageUrls();
    for (String url in imageUrls) {
      await precacheImage(NetworkImage(url), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () async {
            showPostTopicModalBottomSheet(context);
          },
          child: const Icon(Icons.add),
          backgroundColor: AppColors.black_opacity,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: communityService.getAllCommunities(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List communities = snapshot.data!.docs;
                  communities.sort((a, b) => a['time'].compareTo(b['time']));

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: communities.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot e = communities[index];
                      DateTime postTime = DateTime.parse(e['time']);
                      String timeSince = formatTimeSince(postTime);
                      return CommunityCard(
                        user: e['displayName'],
                        avatar:
                            "https://cp.tdung.co/?url=${Uri.encodeComponent(e['image'])}",
                        content: e['content'],
                        time: timeSince,
                        numOfLove: e['numOfLove'],
                        numOfComment: e['numOfComment'],
                        topicCommunityCard: e['topicCommunityCard']
                            .map((e) => TopicCommunityCard(
                                  topicName: e['topicName'],
                                  numOfVocab: 10,
                                  color: e['color'],
                                ))
                            .toList(),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            SizedBox(
              height: Dimensions.height(context, 80),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimeSince(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'bây giờ';
    }
  }
}
