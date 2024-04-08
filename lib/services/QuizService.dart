import 'dart:developer' as dev;
import 'dart:math';

import 'package:cookie_app/models/question.dart';
import 'package:cookie_app/models/word.dart';

class QuizService {
  List<Question> generateQuizQuestions(List<Word> words) {
    List<Question> questions = [];

    for (Word word in words) {
      List<String> options = get3RandomAnswersWithoutCorrectOne(words, word);
      options.add(word.definition);
      options.shuffle();

      questions.add(
        Question(
            question: word.word,
            options: options,
            correctAnswer: word.definition),
      );
    }
    return questions;
  }

  List<String> get3RandomAnswersWithoutCorrectOne(List<Word> words, Word word) {
    List<String> answers = words
        .where((w) => w.word != word.word)
        .map((w) => w.definition)
        .toList();

    answers.shuffle(Random());

    return answers.take(3).toList();
  }
}
