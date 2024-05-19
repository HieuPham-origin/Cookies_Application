import 'package:cookie_app/components/community_card.dart';
import 'package:cookie_app/components/topic_community_card.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPost extends StatefulWidget {
  final String user;
  final String avatar;
  final String content;
  final String time;
  final int numOfComment;
  final List<TopicCommunityCard> topicCommunityCard;
  final String? communityId;
  final List<String> likes;
  const DetailPost(
      {super.key,
      required this.user,
      required this.avatar,
      required this.content,
      required this.time,
      required this.numOfComment,
      required this.topicCommunityCard,
      this.communityId,
      required this.likes});

  @override
  State<DetailPost> createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(Icons.arrow_back_ios),
              Text(
                "Quay lại",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Cookie",
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CommunityCard(
            user: widget.user,
            avatar: widget.avatar,
            content: widget.content,
            time: widget.time,
            numOfComment: widget.numOfComment,
            topicCommunityCard: widget.topicCommunityCard,
            isDetailPost: true,
            communityId: widget.communityId,
            likes: widget.likes,
          ),
        ],
      ),
    );
  }
}
