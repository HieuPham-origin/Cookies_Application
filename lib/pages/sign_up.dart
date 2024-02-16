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

  var _isObsecured;

  void signUpUser() async {
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
      if (passwordController.text != confirmPasswordController.text) {
        showErrorMessage("Passwords are not the same");
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }

      // pop the loading circle
      Navigator.pop(context);
      Navigator.pop(context, true);

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        // show error to user
        showErrorMessage("Email hoặc mật khẩu không chính xác!");
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 180.0,
                      width: 140.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 350,
                      height: 550,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28,
                            ),
                            Text("Đăng ký",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFB99B6B)),
                                )),
                            SizedBox(
                              height: 28,
                            ),

                            //Email field
                            EmailTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false),

                            SizedBox(
                              height: 28,
                            ),

                            //Password field
                            PasswordTextField(
                                controller: passwordController,
                                hintText: "Mật khẩu",
                                obscure: _isObsecured),

                            SizedBox(
                              height: 28,
                            ),

                            //Confirm Password field
                            PasswordTextField(
                                controller: confirmPasswordController,
                                hintText: "Xác nhận mật khẩu",
                                obscure: _isObsecured),

                            SizedBox(
                              height: 28,
                            ),

                            //Sign up button
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFB99B6B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: signUpUser,
                                  child: Text(
                                    "Đăng ký",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
