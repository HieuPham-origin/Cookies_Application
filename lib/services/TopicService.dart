import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/model/topic.dart';
import 'package:cookie_app/model/word.dart';

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

  Stream<QuerySnapshot> getTopicsByUserId(String userId) {
    final topicStream = topics.where('userId', isEqualTo: userId).snapshots();
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

  addWordToTopic(String topicId, String wordId, Word word) {
    topics.doc(topicId).collection('words').doc(wordId).set({
      'word': word.word,
      'definition': word.definition,
      'phonetic': word.phonetic,
      'date': word.date,
      'image': word.image,
      'wordForm': word.wordForm,
      'example': word.example,
      'audio': word.audio,
      'isFav': word.isFav,
      'topicId': word.topicId,
      'status': word.status,
      'userId': word.userId,
    });
  }
}
