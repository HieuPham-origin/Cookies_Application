import 'package:firebase_auth/firebase_auth.dart';

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
      List<dynamic> info = uid.split('@');
      // Name, email address, and profile photo URL
      emailAddress = providerProfile.email;
      name = info[0];
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
}