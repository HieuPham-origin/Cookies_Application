import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final CollectionReference community =
      FirebaseFirestore.instance.collection('communities');

  Future<void> addCommunity(
      User user,
      String content,
      String time,
      int numOfLove,
      int numOfComment,
      List<Map<String, dynamic>> topicCommunityCard) async {
    await community.add({
      'user': user.uid,
      'content': content,
      'time': time,
      'numOfLove': numOfLove,
      'numOfComment': numOfComment,
      'topicCommunityCard': topicCommunityCard,
    });
  }

  Stream<QuerySnapshot> getAllCommunities() {
    final communityStream = community.snapshots();
    return communityStream;
  }
}
