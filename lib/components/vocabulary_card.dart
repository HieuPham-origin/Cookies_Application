// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

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
              const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.word,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: AppColors.cookie,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onSpeakerPressed,
                      child: Icon(
                        CupertinoIcons.volume_up,
                        color: AppColors.coffee,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '${widget.wordForm} ${widget.phonetics}',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      color: Color(0xFF9A9A9A),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1),
                child: widget.definition.isNotEmpty
                    ? Text(
                        widget.definition,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(fontSize: 14),
                        ),
                      )
                    : SizedBox(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.date,
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 12, color: Color(0xFFB59F55)))),
                  Row(
                    children: [
                      LikeButton(
                        size: 24,
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: AppColors.cookie,
                          dotSecondaryColor: AppColors.red,
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            CupertinoIcons.heart_fill,
                            color: isLiked ? AppColors.red : Colors.grey,
                            size: 24,
                          );
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: widget.onSavePressed,
                        child: Icon(
                          CupertinoIcons.bookmark_fill,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: widget.onSharePressed,
                        child: Icon(
                          CupertinoIcons.share,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
