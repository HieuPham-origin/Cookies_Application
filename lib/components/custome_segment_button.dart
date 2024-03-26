import 'package:cookie_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum WordForm { noun, verb, adj, adv }

class CustomeSegmentButton extends StatefulWidget {
  final Function(WordForm) onSelectionChanged;

  const CustomeSegmentButton({super.key, required this.onSelectionChanged});

  @override
  State<CustomeSegmentButton> createState() => _CustomeSegmentButtonState();
}

class _CustomeSegmentButtonState extends State<CustomeSegmentButton> {
  WordForm wordForm = WordForm.noun;

  int? sliding = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl(
          children: const <int, Widget>{
            0: Text(
              'Noun',
              style: TextStyle(color: AppColors.cookie),
            ),
            1: Text(
              'Verb',
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
    );
  }
}
