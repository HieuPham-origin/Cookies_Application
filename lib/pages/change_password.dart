import 'package:cookie_app/components/password_textfield.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePassword> {
  UserService userService = UserService(FirebaseAuth.instance.currentUser!);
  
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  dynamic displayName;
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final userInfo = await userService.getUserInfo();
    setState(() {
      displayName = userInfo['displayName'];
      email = userInfo['uid'];
    });
  }

  Future<void> updateDisplayName() async {
    String currentPassword = passwordController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;
    
    if (newPassword != confirmNewPassword){
      showErrorMessage("Mật khẩu mới không khớp nhau");
    }else{
      try {

        String err_msg = await userService.changePassword(currentPassword, newPassword);
        if (err_msg.isEmpty){
          fetchUserInfo();
          showSuccessMessage('Đổi mật khẩu thành công');
          // Navigate back to information page
          Navigator.pop(context, newPassword);
        }else{
          showErrorMessage(err_msg);
        }
        
      } catch(err){
        showErrorMessage("Có lỗi xảy ra");
      }
    }
  }

  void showErrorMessage(String message) {
    ToastService.showErrorToast(
      context,
      message: message,
    );
  }

  void showSuccessMessage(String message) {
    ToastService.showSuccessToast(
      context,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 24,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          "Thông tin",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 72,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 24, bottom: 64, left: 12, right: 12),
            child: Column(
              children: [
                Text(
                  "Đổi mật khẩu",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                PasswordTextField(
                  controller: passwordController,
                  hintText: "Mật khẩu cũ",
                  obscure: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                PasswordTextField(
                  controller: newPasswordController,
                  hintText: "Mật khẩu mới",
                  obscure: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                PasswordTextField(
                  controller: confirmNewPasswordController,
                  hintText: "Xác nhận mật khẩu mới",
                  obscure: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB99B6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: updateDisplayName,
                      child: Text(
                        "Thay đổi",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
