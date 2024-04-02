import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum WordForm { verb, noun, adj, adv }

class CustomSegmentButton extends StatefulWidget {
  final Function(WordForm) onSelectionChanged;
  String wordForm;
  bool isDisabled;

  CustomSegmentButton(
      {super.key,
      required this.onSelectionChanged,
      required this.wordForm,
      required this.isDisabled});

  @override
  State<CustomSegmentButton> createState() => _CustomSegmentButtonState();
}

class _CustomSegmentButtonState extends State<CustomSegmentButton> {
  @override
  void initState() {
    super.initState();
    switch (widget.wordForm) {
      case 'verb':
        sliding = 0;
        break;
      case 'noun':
        sliding = 1;
        break;
      case 'adj':
        sliding = 2;
        break;
      case 'adv':
        sliding = 3;
        break;
    }
  }

  WordForm wordForm = WordForm.verb;
  int? sliding = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IgnorePointer(
        ignoring: widget.isDisabled,
        child: Opacity(
          opacity: widget.isDisabled ? 0.6 : 1,
          child: CupertinoSlidingSegmentedControl(
            thumbColor: AppColors.creamy,
            children: const <int, Widget>{
              0: Text(
                'Verb',
                style: TextStyle(color: AppColors.cookie),
              ),
              1: Text(
                'Noun',
                style: TextStyle(color: AppColors.cookie),
              ),
              2: Text(
                'Adj',
                style: TextStyle(color: AppColors.cookie),
              ),
              3: Text(
                'Adv',
                style: TextStyle(color: AppColors.cookie),
              ),
            },
            onValueChanged: (int? newValue) {
              setState(() {
                sliding = newValue;
                wordForm = WordForm.values[sliding!];
                widget.onSelectionChanged(wordForm);
              });
            },
            groupValue: sliding,
          ),
        ),
      ),
    );
  }
}
