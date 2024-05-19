// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class VocabularyCard extends StatefulWidget {
  final String word;
  final String phonetics;
  final String definition;
  final String wordForm;
  final String date;
  final bool isFav;
  final String topicId;
  final Function()? onSpeakerPressed;
  final Future<bool?> Function(bool)? onFavoritePressed;
  final Function()? onSavePressed;
  final Function()? onSharePressed;
  final Function()? onTap;
  final int type;

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
      this.onSharePressed,
      this.onTap,
      required this.isFav,
      required this.topicId,
      required this.type});

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
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.vibrate();
            widget.onTap!();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: widget.word,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: AppColors.cookie,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    GestureDetector(
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        color: AppColors.cookie,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                widget.definition.isNotEmpty
                    ? Text(
                        widget.definition,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(fontSize: 14),
                        ),
                      )
                    : SizedBox(),
                widget.type == 1
                    ? Row(
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
                                    color: isLiked
                                        ? AppColors.red
                                        : AppColors.icon_grey,
                                    size: 24,
                                  );
                                },
                                isLiked: widget.isFav,
                                onTap: (isLiked) async {
                                  // Your custom logic here
                                  widget.onFavoritePressed!(isLiked);
                                  bool newLikeState = !isLiked;
                                  return newLikeState; // Return the new state
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: widget.onSavePressed,
                                child: Icon(
                                  CupertinoIcons.bookmark_fill,
                                  color: widget.topicId == ""
                                      ? AppColors.icon_grey
                                      : Colors.yellow.shade700,
                                  size: 24,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: widget.onSharePressed,
                                child: Icon(
                                  CupertinoIcons.share_up,
                                  color: AppColors.icon_grey,
                                  size: 24,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : SizedBox(),
                widget.type == 1
                    ? Row(
                        children: [
                          Text(
                            'Chưa học',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: AppColors.cookie,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 0.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.cookie),
                              backgroundColor: AppColors.grey_light,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
