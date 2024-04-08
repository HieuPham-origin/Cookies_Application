import 'dart:developer';

import 'package:cookie_app/models/question.dart';
import 'package:cookie_app/models/word.dart';

class QuizService {
  List<Question> generateQuizQuestions(List<Word> words) {
    List<Question> questions = [];

    for (Word word in words) {
      List<String> definitions = words
          .where((w) => w.word != word.word)
          .map((w) => w.definition)
          .toList();
      definitions.add(word.definition);

      definitions.shuffle();

      questions.add(Question(
        question: word.word,
        options: definitions,
        correctAnswer: word.definition,
      ));
    }
    log("Q: " + questions[1].question);
    for (int i = 0; i < questions[1].options.length; i++) {
      log(questions[0].options[i]);
    }
    return questions;
  }
}
