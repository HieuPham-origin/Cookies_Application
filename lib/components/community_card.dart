import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CommunityCard extends StatefulWidget {
  final String user;
  final String content;
  final String time;
  final int numOfLove;
  final int numOfComment;
  List<dynamic> topicCommunityCard = [];

  CommunityCard(
      {super.key,
      required this.user,
      required this.content,
      required this.time,
      required this.numOfLove,
      required this.numOfComment,
      required this.topicCommunityCard});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 0, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: Dimensions.width(context, 42),
                    height: Dimensions.height(context, 42),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                        image: AssetImage('assets/girl.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.width(context, 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey_heavy,
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.height(context, 10)),
                          Text(widget.time,
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey_light,
                              ))),
                        ],
                      ),
                      Text(
                        widget.content,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            Container(
              height: Dimensions.height(context, 70),
              child: Expanded(
                child: ListView(
                  dragStartBehavior: DragStartBehavior.start,
                  padding: const EdgeInsets.only(left: 40, right: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < widget.topicCommunityCard.length; i++)
                      Row(
                        children: [
                          widget.topicCommunityCard[i],
                          SizedBox(
                              width: 10), // SizedBox for horizontal spacing
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimensions.width(context, 52),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.heart,
                            color: AppColors.grey_light,
                          ),
                          SizedBox(
                            width: Dimensions.width(context, 5),
                          ),
                          Text(
                            widget.numOfLove.toString(),
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey_light,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Dimensions.width(context, 30),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble,
                            color: AppColors.grey_light,
                          ),
                          SizedBox(
                            width: Dimensions.width(context, 5),
                          ),
                          Text(
                            widget.numOfComment.toString(),
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey_light,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
