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
}
