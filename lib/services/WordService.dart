import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/word.dart';
import 'package:http/http.dart' as http;

class WordService {
  final CollectionReference words =
      FirebaseFirestore.instance.collection('words');

  Future<void> addWord(Word word) async {
    await words.add({
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

  Stream<QuerySnapshot> getAllWords() {
    final wordStream = words.snapshots();
    return wordStream;
  }

  Stream<QuerySnapshot> getWordsByUserId(String userId) {
    final wordStream = words.where('userId', isEqualTo: userId).snapshots();
    return wordStream;
  }

  //count words
  Future<int> countWords(String userId) async {
    int count = 0;
    QuerySnapshot wordsSnapshot =
        await words.where('userId', isEqualTo: userId).get();
    count = wordsSnapshot.docs.length;
    return count;
  }

  Future<Word?> getWordById(String id) async {
    DocumentSnapshot snapshot = await words.doc(id).get();
    return snapshot.exists ? Word.fromSnapshot(snapshot) : null;
  }

  Future<Word?> getWordByUserId(String userId) async {
    QuerySnapshot snapshot =
        await words.where('userId', isEqualTo: userId).get();
    return snapshot.docs.isNotEmpty
        ? Word.fromSnapshot(snapshot.docs.first)
        : null;
  }

  Future<void> updateWord(String id, Word newWord) async {
    await words.doc(id).update({
      'word': newWord.word,
      'definition': newWord.definition,
      'phonetic': newWord.phonetic,
      'date': newWord.date,
      'image': newWord.image,
      'wordForm': newWord.wordForm,
      'example': newWord.example,
      'topicId': newWord.topicId,
      'audio': newWord.audio,
      'status': newWord.status,
    });
  }

  Future<void> updateFavorite(String id, bool isFav) async {
    await words.doc(id).update({
      'isFav': !isFav,
    });
  }

  Future<void> deleteWord(String id) async {
    await words.doc(id).delete();
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
                if (definition.containsKey('example')) {
                  // Print the example
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

  Future<String> getPhoneticValues(String word) async {
    final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
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
      throw Exception('Failed to load phonetic values');
    }
  }
}
