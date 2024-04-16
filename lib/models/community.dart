import 'package:cookie_app/components/topic_community_card.dart';

class Community {
  final String user;
  final String content;
  final String time;
  final int numOfLove;
  final int numOfComment;
  List<TopicCommunityCard> topicCommunityCard = [];

  Community(
      {required this.user,
      required this.content,
      required this.time,
      required this.numOfLove,
      required this.numOfComment,
      required this.topicCommunityCard});
}
