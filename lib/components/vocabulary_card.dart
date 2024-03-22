// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocabularyCard extends StatefulWidget {
  final String word;
  final String phonetics;
  final String definition;
  final String wordForm;
  final String date;
  final Function()? onSpeakerPressed;
  final Function()? onFavoritePressed;
  final Function()? onSavePressed;
  final Function()? onSharePressed;

  const VocabularyCard(
      {super.key,
      required this.word,
      required this.phonetics,
      required this.definition,
      required this.wordForm,
      required this.date,
      this.onSpeakerPressed,
      this.onFavoritePressed,
      this.onSavePressed,
      this.onSharePressed});

  @override
  State<VocabularyCard> createState() => _VocabularyCardState();
}

class _VocabularyCardState extends State<VocabularyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
      child: Card(
        elevation: 0,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.word,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: AppColors.cookie,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                  Text('${widget.wordForm} ${widget.phonetics}',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color(0xFF9A9A9A),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              fontSize: 12))),
                  Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 1),
                    child: Text(widget.definition,
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(fontSize: 14))),
                  ),
                  Text(widget.date,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12, color: Color(0xFFB59F55)))),
                ],
              ),

              //Icon column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: widget.onSpeakerPressed,
                      icon: Icon(
                        Icons.volume_up,
                        color: AppColors.cookie,
                        size: 24,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: widget.onFavoritePressed,
                          icon: Icon(
                            CupertinoIcons.heart_solid,
                            color: Colors.grey,
                            size: 24,
                          )),
                      IconButton(
                          onPressed: widget.onSavePressed,
                          icon: Icon(
                            CupertinoIcons.bookmark_fill,
                            color: Colors.grey,
                            size: 24,
                          )),
                      IconButton(
                          onPressed: widget.onSharePressed,
                          icon: Icon(
                            CupertinoIcons.share,
                            color: Colors.grey,
                            size: 24,
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
