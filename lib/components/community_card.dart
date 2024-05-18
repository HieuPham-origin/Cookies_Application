import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/pages/detail_post.dart';
import 'package:cookie_app/pages/detail_topic_for_community.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class CommunityCard extends StatefulWidget {
  final String user;
  final String avatar;
  final String content;
  final String time;
  final int numOfLove;
  final int numOfComment;
  final bool isDetailPost;
  List<TopicCommunityCard> topicCommunityCard;
  String? communityId;

  CommunityCard({
    super.key,
    required this.user,
    required this.avatar,
    required this.content,
    required this.time,
    required this.numOfLove,
    required this.numOfComment,
    required this.topicCommunityCard,
    required this.isDetailPost,
    this.communityId,
  });

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        if (!widget.isDetailPost) {
          Navigator.of(context, rootNavigator: true).push(PageTransition(
              child: DetailPost(
                user: widget.user,
                avatar: widget.avatar,
                content: widget.content,
                time: widget.time,
                numOfLove: widget.numOfLove,
                numOfComment: widget.numOfComment,
                topicCommunityCard: widget.topicCommunityCard,
                communityId: widget.communityId,
              ),
              type: PageTransitionType.rightToLeft));
        }
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            side: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                width: 0.3,
                color: Colors.black), // Make the default border transparent

            borderRadius: BorderRadius.all(Radius.circular(0))),
        surfaceTintColor: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 0, top: 10, bottom: 10),
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
                        color:
                            widget.avatar.isNotEmpty ? null : Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50), // This applies to the CachedNetworkImage

                        child: CachedNetworkImage(
                          memCacheWidth: 150, // memory cache width
                          memCacheHeight: 200, // memory cache height
                          imageUrl: widget.avatar,
                          placeholder: (context, url) => SizedBox(
                            width:
                                20, // Adjust the width as per your requirement
                            height:
                                20, // Adjust the height as per your requirement
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.cookie,
                                strokeWidth:
                                    2, // Adjust the strokeWidth as per your requirement
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                child: ListView(
                  dragStartBehavior: DragStartBehavior.start,
                  padding: const EdgeInsets.only(left: 40, right: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < widget.topicCommunityCard.length; i++)
                      widget.isDetailPost
                          ? InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(PageTransition(
                                  child: DetailTopicCommunity(
                                    topicCommunityCard:
                                        widget.topicCommunityCard[i],
                                    data: {
                                      "topicName": widget
                                          .topicCommunityCard[i].topicName,
                                      "user": widget.user,
                                      "avatar": widget.avatar,
                                      "content": widget.content,
                                      "time": widget.time,
                                      "numOfLove": widget.numOfLove,
                                      "numOfComment": widget.numOfComment
                                    },
                                    communityId: widget.communityId,
                                  ),
                                  type: PageTransitionType.rightToLeft,
                                ));
                              },
                              child: Row(
                                children: [
                                  widget.topicCommunityCard[i],
                                  SizedBox(
                                      width:
                                          10), // SizedBox for horizontal spacing
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                widget.topicCommunityCard[i],
                                SizedBox(
                                    width:
                                        10), // SizedBox for horizontal spacing
                              ],
                            )
                  ],
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
      ),
    );
  }
}
