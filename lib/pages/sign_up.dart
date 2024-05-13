// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';

import '../components/password_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _isObsecured;

  void signUpUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ToastService.showErrorToast(context, message: "Mật khẩu không khớp");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SpinKitSquareCircle(
            color: Color(0xFFB99B6B),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigate to the verification screen
      Navigator.pop(context);
      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showErrorMessage("Email hoặc mật khẩu không chính xác!");
      } else {
        showErrorMessage("Error creating account: ${e.message}");
      }
    }
  }

  void showErrorMessage(String errorMessage) {
    ToastService.showErrorToast(
      context,
      message: errorMessage,
    );
  }

  void showSuccessMessage(String successMessage) {
    ToastService.showSuccessToast(
      context,
      message: successMessage,
    );
  }

  @override
  void initState() {
    super.initState();
    _isObsecured = true;
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
                    height: screenSize.height * 0.7,
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
                            Text("Đăng ký",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB99B6B)),
                                )),
                            SizedBox(
                              height: 20,
                            ),

                            //Email field
                            EmailTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false),

                            SizedBox(
                              height: 20,
                            ),

                            //Password field
                            PasswordTextField(
                                controller: passwordController,
                                hintText: "Mật khẩu",
                                obscure: _isObsecured),

                            SizedBox(
                              height: 20,
                            ),

                            //Confirm Password field
                            PasswordTextField(
                                controller: confirmPasswordController,
                                hintText: "Xác nhận mật khẩu",
                                obscure: _isObsecured),

                            SizedBox(
                              height: 50,
                            ),

                            //Sign up button
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
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      signUpUser();
                                    }
                                  },
                                  child: Text(
                                    "Đăng ký",
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
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Đã có tài khoản",
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
