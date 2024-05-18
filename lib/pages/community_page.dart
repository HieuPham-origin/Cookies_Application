import 'dart:developer';

import 'package:cookie_app/components/community_card.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_community_modal.dart';
import 'package:cookie_app/components/modal_bottom_sheet/add_wallpost.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/models/community.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/constants.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  // const CommunityPage({super.key});
  // add log to check if the widget is being built
  CommunityPage() {
    log('CommunityPage is being built');
  }

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

final GlobalKey<WallPostState> bottomSheetKey = GlobalKey<WallPostState>();

class _CommunityPageState extends State<CommunityPage> {
  CommunityService communityService = CommunityService();
  TopicService topicService = TopicService();
  UserService userService = UserService(user);

  // List<String> avatarUrls = [];
  bool flag = false;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getAvatarUrl(String userId) async {
    Reference storage = FirebaseStorage.instance.ref();
    Reference referenceImageToUpload =
        storage.child('avatars').child(userId).child("avatar");

    try {
      final url = await referenceImageToUpload.getDownloadURL();
      return url;
    } catch (e) {
      log(e.toString());
      return "https://cdn.discordapp.com/attachments/1049968383082373191/1239879020414238844/logo.png?ex=66452f92&is=6643de12&hm=ff1ce84b67b83ecb0c8dcdae52ad72619fe4fbeaf33a654188df4613b083f698&";
    }
  }

  //funtionc to get all userId in AppConstants.communities
  Future<void> getAllCommunities() async {
    if (flag) {
      return;
    }
    AppConstants.communities.clear();

    AppConstants.avatarUrl =
        await getAvatarUrl(FirebaseAuth.instance.currentUser!.uid);
    final result = await communityService.getCommunitySortByTimeSnapShot();
    for (var doc in result.docs) {
      AppConstants.communities.add(Community(
        // communityId: doc.id,
        userId: doc['userId'],
        avatar: await getAvatarUrl(doc['userId']),
        displayName: doc['displayName'],
        content: doc['content'],
        time: doc['time'],
        numOfLove: doc['numOfLove'],
        numOfComment: doc['numOfComment'],
        topicCommunityCard:
            await loadTopic((doc['topicCommunityCard']).cast<String>()),
      ));
    }
    setState(() {
      flag = true;
    });
  }

  //load topic from topicId
  Future<List<TopicCommunityCard>> loadTopic(List<String> topicId) async {
    List<TopicCommunityCard> listTopic = [];
    for (var id in topicId) {
      final topic = await topicService.getTopicById(id);
      listTopic.add(TopicCommunityCard(
        topicName: topic.topicName,
        numOfVocab: 10,
        color: topic.color,
        topicId: topic.topicId,
      ));
    }
    return listTopic;
  }

  Future<List<Topic>> loadTopicFromList(List<String> topicId) async {
    List<Topic> listTopic = [];
    for (var id in topicId) {
      final topic = await topicService.getTopicById(id);
      listTopic.add(topic);
    }
    return listTopic;
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
            showPostTopicModalBottomSheet(context, AppConstants.avatarUrl);
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
      body: NestedScrollView(
        body: RefreshIndicator(
          onRefresh: () async {
            flag = false;
            await getAllCommunities();
          },
          child: FutureBuilder(
            future: getAllCommunities(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.cookie,
                    strokeWidth: 2,
                  ),
                );
              }

              return ListView.builder(
                padding:
                    EdgeInsets.only(bottom: Dimensions.height(context, 80)),
                reverse: false,
                itemCount: AppConstants.communities.length,
                itemBuilder: (BuildContext context, int index) {
                  Community e = AppConstants.communities[index];
                  DateTime postTime = DateTime.parse(e.time);
                  String timeSince = formatTimeSince(postTime);

                  return CommunityCard(
                    user: e.displayName,
                    avatar: e.avatar,
                    content: e.content,
                    time: timeSince,
                    numOfLove: e.numOfLove,
                    numOfComment: e.numOfComment,
                    topicCommunityCard: e.topicCommunityCard,
                    isDetailPost: false,
                    // communityId: e.communityId,
                  );
                },
              );
            },
          ),
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              forceElevated: innerBoxIsScrolled,
              toolbarHeight: 40,
              title: const Text(
                'Cộng đồng',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ];
        },
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
