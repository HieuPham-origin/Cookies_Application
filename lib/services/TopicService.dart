import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/model/topic.dart';

class TopicService {
  final CollectionReference topics =
      FirebaseFirestore.instance.collection('topics');

  Future<void> addTopic(Topic topic) async {
    await topics.add({
      'topicName': topic.topicName,
      'isPublic': topic.isPublic,
      'userId': topic.userId,
      'userEmail': topic.userEmail,
    });
  }

  Stream<QuerySnapshot> getAllTopics() {
    final topicStream = topics.snapshots();
    return topicStream;
  }

  Future<void> updateTopic(String topicId, Topic newTopic) async {
    await topics.doc(topicId).update({
      'topicName': newTopic.topicName,
      'isPublic': newTopic.isPublic,
      'userId': newTopic.userId,
      'userEmail': newTopic.userEmail,
    });
  }

  Future<void> deleteTopic(String topicId) async {
    await topics.doc(topicId).delete();
  }
}
