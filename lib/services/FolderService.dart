import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/folder.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/models/word.dart';

class FolderService {
  final CollectionReference folders =
      FirebaseFirestore.instance.collection('folders');
  final CollectionReference topics =
      FirebaseFirestore.instance.collection('topics');

  Stream<QuerySnapshot> getAll() {
    final folderStream = folders.snapshots();
    return folderStream;
  }

  Future<void> addFolder(Folder folder) async {
    await folders.add(
      {
        'folderName': folder.folderName,
        'userId': folder.userId,
      },
    );
  }

  Future<void> deleteFolder(String id) async {
    await folders.doc(id).delete();
  }

  Future<void> updateFolder(String id, Folder folder) async {
    await folders.doc(id).update({
      'folderName': folder.folderName,
      'userId': folder.userId,
    });
  }

  //add topic to folder
  Future<void> addTopicToFolder(String folderId, Topic topic, String topicId,
      Map<String, dynamic> topicData) async {
    DocumentReference newTopicRef =
        folders.doc(folderId).collection('topics').doc(topicId);
    await newTopicRef.set(topicData);
    copyWordSubCollection(topicId, newTopicRef);
  }

  Future<void> copyWordSubCollection(
      String topicId, DocumentReference newTopicRef) {
    return topics.doc(topicId).collection('words').get().then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        await newTopicRef
            .collection('words')
            .doc(doc.id)
            .set(doc.data() as Map<String, dynamic>);
      }
    });
  }

  //get all topics in folder
  Stream<QuerySnapshot> getTopicsInFolder(String folderId) {
    final topicStream = folders.doc(folderId).collection('topics').snapshots();
    return topicStream;
  }
}
