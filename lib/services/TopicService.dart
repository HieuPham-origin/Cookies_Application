import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';

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

  Stream<QuerySnapshot> getTopicsByUserId(String id) {
    final topicStream = topics.where('userId', isEqualTo: id).snapshots();
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

  Future<List<Word>> getWordsForTopic(String topicId) async {
    List<Word> wordsList = [];

    DocumentReference topicRef = topics.doc(topicId);

    QuerySnapshot wordsSnapshot = await topicRef.collection('words').get();
    for (var wordDoc in wordsSnapshot.docs) {
      Word word = Word.fromSnapshot(wordDoc);
      wordsList.add(word);
    }

    return wordsList;
  }

  Future<void> deleteTopic(String topicId) async {
    await topics.doc(topicId).delete();
  }
}
