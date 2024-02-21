// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final Function()? onPressed;
  const TitleWidget(
      {super.key, this.onPressed, required this.title});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFFCF7E3),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                widget.title,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF8F6D21))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
