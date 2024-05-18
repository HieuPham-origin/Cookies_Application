import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String? topicId;
  final String topicName;
  final bool isPublic;
  final String userId;
  final String? userEmail;
  final String color; // Add color field

  Topic({
    this.topicId,
    required this.topicName,
    required this.isPublic,
    required this.userId,
    required this.userEmail,
    required this.color, // Initialize color field in the constructor
  });
}
