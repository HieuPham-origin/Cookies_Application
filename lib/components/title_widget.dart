// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final Function()? onPressed;
  const TitleWidget({super.key, this.onPressed, required this.title});

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
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
            child: Text(
              widget.title,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.icon_grey,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
