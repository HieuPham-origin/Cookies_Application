import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class StoreData {
  Future<String> uploadAvatarToStorage(String childName, Uint8List file) async {
    Reference reference = _storage.ref().child(childName);
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String response = "Some err occurred";
    try {
      // Xác thực người dùng
      User? user = _auth.currentUser;
      if (user != null) {
        // Tải lên ảnh đại diện
        String avatar = await uploadAvatarToStorage(user.uid, file);

        // Lưu trữ đường dẫn ảnh đại diện trong thông tin người dùng
        await user.updatePhotoURL(avatar);

        response = 'Success';
      } else {
        response = 'User not logged in';
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }
}