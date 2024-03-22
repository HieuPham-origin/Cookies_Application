import 'package:cookie_app/models/word.dart';
import 'package:flutter/material.dart';

enum WordForm { noun, verb, adj, adv }

class SingleChoice extends StatefulWidget {
  final Function(WordForm) onSelectionChanged;
  const SingleChoice({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  WordForm wordForm = WordForm.noun;
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<WordForm>(
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.red,
        selectedForegroundColor: Colors.white,
        selectedBackgroundColor: Colors.green,
        visualDensity: VisualDensity(horizontal: 3, vertical: -2),
      ),
      showSelectedIcon: false,
      segments: const <ButtonSegment<WordForm>>[
        ButtonSegment<WordForm>(
          value: WordForm.noun,
          label: Text('Noun'),
        ),
        ButtonSegment<WordForm>(
          value: WordForm.verb,
          label: Text('Verb'),
        ),
        ButtonSegment<WordForm>(
          value: WordForm.adj,
          label: Text('Adj'),
        ),
        ButtonSegment<WordForm>(
          value: WordForm.adv,
          label: Text('Adv'),
        ),
      ],
      selected: <WordForm>{wordForm},
      onSelectionChanged: (Set<WordForm> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          wordForm = newSelection.first;
          widget.onSelectionChanged(wordForm);
        });
      },
    );
  }
}
