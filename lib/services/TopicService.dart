import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';
import 'package:http/http.dart' as http;

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
