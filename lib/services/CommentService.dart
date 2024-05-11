import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final CollectionReference community =
      FirebaseFirestore.instance.collection('communities');

  Future<void> addComment(String postId, String commentText, String userId) {
    return community.doc(postId).collection('comments').add({
      'commentText': commentText,
      'userId': userId,
      'time': DateTime.now().toIso8601String(),
    });
  }
}
