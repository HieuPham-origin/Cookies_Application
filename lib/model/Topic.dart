class Topic {
  final String topicName;
  final bool isPublic;
  final String userId;
  final String? userEmail;

  Topic(
      {required this.topicName,
      required this.isPublic,
      required this.userId,
      required this.userEmail});
}
