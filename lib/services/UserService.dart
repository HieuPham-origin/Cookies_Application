import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toasty_box/toasty_box.dart';

class UserService {
  User user = FirebaseAuth.instance.currentUser!;

  UserService(User user) {
    this.user = user;
  }

  Map<String, dynamic> getUserInfo() {
    dynamic uid, name, emailAddress;
    for (final providerProfile in user.providerData) {
      // UID specific to the provider
      uid = providerProfile.uid;
      // List<dynamic> info = uid.split('@');
      // Name, email address, and profile photo URL
      emailAddress = providerProfile.email;
      name = providerProfile.displayName;
      // final profilePhoto = providerProfile.photoURL;
    }
    return {
      "uid": uid,
      "displayName": name,
      "emailAddress": emailAddress,
    };
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    await user.updateDisplayName(newDisplayName);
  }

  Future<void> updateProfilePicture(String image) async {
    await user.updatePhotoURL(image);
  }

  Future<Uint8List?> getProfileImage() async {
    try {
      if (user.photoURL != null) {
        final Reference ref = FirebaseStorage.instance.refFromURL(user.photoURL!);
        final Uint8List? imageData = await ref.getData();
        return imageData;
      }
    } catch (error) {
      // Xử lý lỗi
    }
    return null;
  }

  Future<String> changePassword(
      String currentPassword, String newPassword) async {
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      print("success");
      return "";
    } catch (err) {
      print("Lỗi $err");
      return "Mật khẩu hiện tại không đúng";
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
