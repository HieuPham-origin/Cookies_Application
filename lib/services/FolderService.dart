import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/folder.dart';

class FolderService {
  final CollectionReference folders =
      FirebaseFirestore.instance.collection('folders');

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
}
