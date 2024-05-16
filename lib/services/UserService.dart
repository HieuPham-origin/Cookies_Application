import 'dart:developer';
import 'dart:typed_data';

import 'package:cookie_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UserService {
  User user = FirebaseAuth.instance.currentUser!;

  UserService(User user) {
    this.user = user;
  }

  Future<void> loadAvatar() async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('avatars');

    Reference referenceChildDirImages = referenceDirImages.child(user.uid);
    Reference referenceImageToUpload = referenceChildDirImages.child("avatar");

    try {
      final url = await referenceImageToUpload.getDownloadURL();
      AppConstants.avatarUrl = url;
    } catch (e) {
      log(e.toString());
      AppConstants.avatarUrl =
          "https://cdn.discordapp.com/attachments/1049968383082373191/1239879020414238844/logo.png?ex=66452f92&is=6643de12&hm=ff1ce84b67b83ecb0c8dcdae52ad72619fe4fbeaf33a654188df4613b083f698&";
    }
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

  //get displayName by userId
  Future<String> getDisplayName(String userId) async {
    final Stream<User?> userById = FirebaseAuth.instance
        .authStateChanges()
        .where((user) => user!.uid == userId);
    return userById.first.then((user) => user!.displayName!);
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
        final Reference ref =
            FirebaseStorage.instance.refFromURL(user.photoURL!);
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
