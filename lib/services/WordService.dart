import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/model/word.dart';

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
      'audio': newWord.audio,
      'isFav': newWord.isFav,
      'topicId': newWord.topicId,
      'status': newWord.status,
      'userId': newWord.userId,
    });
  }

  Future<void> deleteWord(String id) async {
    await words.doc(id).delete();
  }
}
