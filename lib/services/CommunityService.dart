import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityService {
  final CollectionReference community =
      FirebaseFirestore.instance.collection('communities');

  Future<void> addCommunity(
      String userId,
      String displayName,
      String image,
      String content,
      String time,
      int numOfLove,
      int numOfComment,
      List<Map<String, dynamic>> topicCommunityCard) async {
    await community.add({
      'userId': userId,
      'displayName': displayName,
      'image': image,
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

  Future<QuerySnapshot> getAllCommunitiesToLoadImage() {
    return community.get();
  }

  //update all image of community
  Future<void> updateImage(String userId, String image) async {
    await community.doc(userId).update({'image': image});
  }

  Future<void> updateImageForAllCommunitiesByUserId(
      String userId, String newImage) async {
    // Query for all documents where 'userId' matches the given userId
    final querySnapshot =
        await community.where('userId', isEqualTo: userId).get();

    // Iterate over each document and update the 'image' field
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'image': newImage});
    }
  }
}
