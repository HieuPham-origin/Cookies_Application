import 'package:cookie_app/components/topic_community_card.dart';

class Community {
  final String? communityId;
  final String userId;
  String avatar;
  final String displayName;
  final String content;
  final String time;
  List<String> likes = [];
  final int numOfComment;
  List<TopicCommunityCard> topicCommunityCard = [];

  Community({
    this.communityId,
    required this.userId,
    required this.avatar,
    required this.displayName,
    required this.content,
    required this.time,
    required this.likes,
    required this.numOfComment,
    required this.topicCommunityCard,
  });
}
