import 'dart:developer' as dev;
import 'dart:math';

import 'package:cookie_app/models/question.dart';
import 'package:cookie_app/models/word.dart';

class QuizService {
  List<Question> generateQuizQuestions(List<Word> words, bool reverse) {
    List<Question> questions = [];

    for (Word word in words) {
      List<String> options =
          get3RandomAnswersWithoutCorrectOne(words, word, reverse);

      if (reverse) {
        options.add(word.word);
        options.shuffle();
        questions.add(
          Question(
              question: word.definition,
              options: options,
              correctAnswer: word.word),
        );
      } else {
        options.add(word.definition);
        options.shuffle();
        questions.add(
          Question(
              question: word.word,
              options: options,
              correctAnswer: word.definition),
        );
      }
    }
    return questions;
  }

  List<String> get3RandomAnswersWithoutCorrectOne(
      List<Word> words, Word word, bool reverse) {
    List<String> answers;
    if (reverse) {
      answers = words
          .where((w) => w.definition != word.definition)
          .map((w) => w.word)
          .toList();
    } else {
      answers = words
          .where((w) => w.word != word.word)
          .map((w) => w.definition)
          .toList();
    }

    answers.shuffle(Random());

    return answers.take(3).toList();
  }
}
