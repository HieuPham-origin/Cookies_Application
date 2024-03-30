import 'package:cloud_firestore/cloud_firestore.dart';

class Word {
  final String word;
  final String definition;
  final String phonetic;
  final String date;
  final String image;
  final String wordForm;
  final String example;
  final String audio;
  final bool isFav;
  final String topicId;
  final int status;
  final String userId;

  Word(
      {required this.word,
      required this.definition,
      required this.phonetic,
      required this.date,
      required this.image,
      required this.wordForm,
      required this.example,
      required this.audio,
      required this.isFav,
      required this.topicId,
      required this.status,
      required this.userId});

  factory Word.fromSnapshot(DocumentSnapshot snapshot) {
    return Word(
      word: snapshot['word'],
      definition: snapshot['definition'],
      phonetic: snapshot['phonetic'],
      date: snapshot['date'],
      image: snapshot['image'],
      wordForm: snapshot['wordForm'],
      example: snapshot['example'],
      audio: snapshot['audio'],
      isFav: snapshot['isFav'],
      topicId: snapshot['topicId'],
      status: snapshot['status'],
      userId: snapshot['userId'],
    );
  }
}
