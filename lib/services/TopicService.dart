import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class TopicService {
  final CollectionReference topics =
      FirebaseFirestore.instance.collection('topics');

  Future<void> addTopic(Topic topic) async {
    await topics.add(
      {
        'topicName': topic.topicName,
        'isPublic': topic.isPublic,
        'userId': topic.userId,
        'userEmail': topic.userEmail,
        'color': topic.color, // Include color when adding a new topic
      },
    );
  }

  Stream<QuerySnapshot> getAllTopics() {
    final topicStream = topics.snapshots();
    return topicStream;
  }

  Stream<QuerySnapshot> getTopicsByUserId(String userId) {
    final topicStream = topics.where('userId', isEqualTo: userId).snapshots();
    return topicStream;
  }

  ValueStream<List<Word>> convertListToStream(List<Word> words) {
    final wordStream = BehaviorSubject<List<Word>>.seeded(words).stream;
    return wordStream;
  }

  Future<void> updateTopic(String topicId, Topic newTopic) async {
    await topics.doc(topicId).update({
      'topicName': newTopic.topicName,
      'isPublic': newTopic.isPublic,
      'userId': newTopic.userId,
      'userEmail': newTopic.userEmail,
      'color': newTopic.color,
    });
  }

  //function to get list of topic id
  Future<List<String>> getTopicIdList(String userId) async {
    List<String> topicIdList = [];
    QuerySnapshot topicsSnapshot =
        await topics.where('userId', isEqualTo: userId).get();
    for (var topicDoc in topicsSnapshot.docs) {
      topicIdList.add(topicDoc.id);
    }
    return topicIdList;
  }

  // get all favorite words in list of topic id
  Future<List<Word>> getAllFavoriteWords(List<String> topicId) async {
    List<Word> wordsList = [];
    for (var id in topicId) {
      QuerySnapshot wordsSnapshot = await topics
          .doc(id)
          .collection('words')
          .where('isFav', isEqualTo: true)
          .get();
      for (var wordDoc in wordsSnapshot.docs) {
        Word word = Word.fromSnapshot(wordDoc);
        wordsList.add(word);
      }
    }
    return wordsList;
  }

  //get all id favorite words in list of topic id
  Future<List<String>> getAllFavoriteWordsId(List<String> topicId) async {
    List<String> wordsIdList = [];
    for (var id in topicId) {
      QuerySnapshot wordsSnapshot = await topics
          .doc(id)
          .collection('words')
          .where('isFav', isEqualTo: true)
          .get();
      for (var wordDoc in wordsSnapshot.docs) {
        wordsIdList.add(wordDoc.id);
      }
    }
    return wordsIdList;
  }

  //count word in topic
  Future<int> countWordsInTopic(String topicId) async {
    int count = 0;
    QuerySnapshot wordsSnapshot =
        await topics.doc(topicId).collection('words').get();
    count = wordsSnapshot.docs.length;
    return count;
  }

  //count topic
  Future<int> countTopics(String userId) async {
    int count = 0;
    QuerySnapshot topicsSnapshot =
        await topics.where('userId', isEqualTo: userId).get();
    count = topicsSnapshot.docs.length;
    return count;
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

  //get words for topic
  Stream<QuerySnapshot> getWordsForTopicStream(String topicId) {
    final wordStream = topics.doc(topicId).collection('words').snapshots();
    return wordStream;
  }

  //update words for topic
  Future<void> updateWordForTopic(
      String topicId, String wordId, Word newWord) async {
    await topics.doc(topicId).collection('words').doc(wordId).update({
      'word': newWord.word,
      'definition': newWord.definition,
      'phonetic': newWord.phonetic,
      'date': newWord.date,
      'image': newWord.image,
      'wordForm': newWord.wordForm,
      'example': newWord.example,
      'audio': newWord.audio,
      'status': newWord.status,
      'userId': newWord.userId,
    });
  }

  //update favorite word for topic
  Future<void> updateFavoriteWordForTopic(
      String topicId, String wordId, bool isFav) async {
    await topics.doc(topicId).collection('words').doc(wordId).update({
      'isFav': !isFav,
    });
  }

  //update favorite word for topic without wordId
  Future<void> updateFavoriteWordForTopicWithoutWordId(
      String topicId, bool isFav) async {
    QuerySnapshot wordsSnapshot =
        await topics.doc(topicId).collection('words').get();
    for (var wordDoc in wordsSnapshot.docs) {
      await topics.doc(topicId).collection('words').doc(wordDoc.id).update({
        'isFav': !isFav,
      });
    }
  }

  //delete word for topic
  Future<void> deleteWordForTopic(String topicId, String wordId) async {
    await topics.doc(topicId).collection('words').doc(wordId).delete();
  }

  Future<void> deleteTopic(String topicId) async {
    await topics.doc(topicId).delete();
  }

  Future<String> getPhoneticValues(String word) async {
    final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      List<dynamic> jsonResponse = json.decode(response.body);

      for (var item in jsonResponse) {
        // Assuming each item might have a 'phonetics' list.
        if (item.containsKey('phonetics') && item['phonetics'].isNotEmpty) {
          for (var phonetic in item['phonetics']) {
            // Check if 'text' exists in phonetic
            if (phonetic.containsKey('text')) {
              // Print the phonetic text
              return phonetic['text'];
            }
          }
        }
      }
      throw Exception('Phonetic text not found');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load phonetic values');
    }
  }

  Future<String> getExample(String word) async {
    final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      List<dynamic> jsonResponse = json.decode(response.body);

      for (var item in jsonResponse) {
        // Assuming each item might have a 'meanings' list.
        if (item.containsKey('meanings') && item['meanings'].isNotEmpty) {
          for (var meaning in item['meanings']) {
            // Check if 'definitions' exists in meaning
            if (meaning.containsKey('definitions') &&
                meaning['definitions'].isNotEmpty) {
              for (var definition in meaning['definitions']) {
                // Check if 'example' exists in definition
                if (definition.containsKey('example')) {
                  // Print the example
                  print(definition['example']);
                  return definition['example'];
                }
              }
            }
          }
        }
      }
      throw Exception('Example not found');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load example');
    }
  }

  addWordToTopic(String topicId, String wordId, Word word) {
    topics.doc(topicId).collection('words').add({
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

  Future<Topic> getTopicById(String id) async {
    return topics.doc(id).get().then((value) {
      return Topic(
        topicId: value.id,
        topicName: value['topicName'],
        isPublic: value['isPublic'],
        userId: value['userId'],
        userEmail: value['userEmail'],
        color: value['color'],
      );
    });
  }
}
