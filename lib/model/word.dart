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
  final int topicId;

  final bool status;
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
}
