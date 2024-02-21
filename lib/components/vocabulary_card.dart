// ignore_for_file: prefer_const_constructors

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
        elevation: 2,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 8),
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
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))),
                  SizedBox(height: 5),
                  Text('${widget.wordForm} /${widget.phonetics}/',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              color: Color(0xFF9A9A9A),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              fontSize: 13))),
                  SizedBox(height: 5),
                  Text(widget.definition,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(fontSize: 16))),
                  SizedBox(height: 5),
                  Text(widget.date,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 16, color: Color(0xFFB59F55)))),
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
                        color: Colors.red,
                        size: 32,
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: widget.onFavoritePressed,
                          icon: Icon(
                            CupertinoIcons.heart_solid,
                            color: Colors.grey,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: widget.onSavePressed,
                          icon: Icon(
                            CupertinoIcons.bookmark_fill,
                            color: Colors.grey,
                            size: 28,
                          )),
                      IconButton(
                          onPressed: widget.onSharePressed,
                          icon: Icon(
                            CupertinoIcons.share,
                            color: Colors.grey,
                            size: 30,
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
