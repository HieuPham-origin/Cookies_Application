// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/password_textfield.dart';
import 'package:cookie_app/pages/forgot_password.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:cookie_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var _isObsecured;

  @override
  void initState() {
    super.initState();
    _isObsecured = true;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // User user = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void signInUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await UserService(FirebaseAuth.instance.currentUser!).loadAvatar();
      // pop the loading circle
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // show error to user
        showErrorMessage("Email hoặc mật khẩu không chính xác !");
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

  Future<void> signUpAndDisplayResult(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/signup');

    if (!context.mounted) return;
    if (result == true) showSuccessMessage("Đăng ký tài khoản thành công");
  }

  void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFEF5E7),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: screenSize.height * 0.24,
                    width: screenSize.width * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain,
                    )),
                  ),
                  Container(
                    width: screenSize.width * 0.88,
                    height: screenSize.height * 0.6,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      surfaceTintColor: Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text("Đăng nhập",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB99B6B)),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            EmailTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false),
                            SizedBox(
                              height: 20,
                            ),
                            PasswordTextField(
                                controller: passwordController,
                                hintText: "Nhập mật khẩu",
                                obscure: _isObsecured),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Forgot_Password()));
                                },
                                child: const Text('Quên mật khẩu ?',
                                    style: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shadowColor: Colors.black,
                                    backgroundColor: Color(0xFFB99B6B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () => {
                                        if (_formKey.currentState!.validate())
                                          signInUser()
                                      },
                                  child: Text(
                                    "Đăng Nhập",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () => signUpAndDisplayResult(context),
                                child: Text(
                                  "Tạo tài khoản",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF9A9A9A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
