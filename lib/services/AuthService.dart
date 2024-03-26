import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
    Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Password reset email sent successfully.");
    } catch (error) {
      print("Error sending password reset email: $error");
    }
  }
}

