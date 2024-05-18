import 'dart:developer';
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
      String content,
      String time,
      int numOfLove,
      int numOfComment,
      List<String> topicCommunityCard) async {
    await community.add({
      'userId': userId,
      'displayName': displayName,
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

  //get community sort by time
  Stream<QuerySnapshot> getCommunitySortByTime() {
    final communityStream =
        community.orderBy('time', descending: false).snapshots();
    return communityStream;
  }

  //add collection ranking
  Future<void> addRanking(String userId, String email, int point,
      String communityId, String topicId) async {
    await community.doc(communityId).collection('ranking').add({
      'userId': userId,
      'email': email,
      'point': point,
      'topicId': topicId,
    });
  }

  //compare point by topicId and userId in ranking collection
  Future<void> comparePoint(String userId, String topicId, int point) async {
    final querySnapshot = await community
        .where('userId', isEqualTo: userId)
        .where('topicId', isEqualTo: topicId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      await addRanking(userId, FirebaseAuth.instance.currentUser!.email!, point,
          querySnapshot.docs[0].id, topicId);
    } else {
      for (var doc in querySnapshot.docs) {
        if (doc['point'] < point) {
          await community
              .doc(doc.id)
              .update({'point': point, 'userId': userId});
        }
      }
    }
  }

  //compare point by topicId and userId in ranking collection and add new document if not exist
  Future<void> comparePointAndAddNewDocument(
      String userId, String topicId, int point, String communityId) async {
    final querySnapshot = await community
        .doc(communityId)
        .collection('ranking')
        .where('userId', isEqualTo: userId)
        .where('topicId', isEqualTo: topicId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      await addRanking(userId, FirebaseAuth.instance.currentUser!.email!, point,
          communityId, topicId);
    } else {
      for (var doc in querySnapshot.docs) {
        if (doc['point'] < point) {
          await community
              .doc(communityId)
              .collection('ranking')
              .doc(doc.id)
              .update({'point': point});
        }
      }
    }
  }

  Future<QuerySnapshot> getCommunitySortByTimeSnapShot() {
    return community.orderBy('time', descending: false).get();
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
