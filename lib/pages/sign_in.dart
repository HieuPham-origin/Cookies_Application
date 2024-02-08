// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/components/email_textfield.dart';
import 'package:cookie_app/components/password_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sign_up.dart';

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

  void signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // WRONG EMAIL
      Navigator.pop(context);
      if (e.code == 'invalid-email') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'invalid-credential') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
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
                      height: 500,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            Text("Đăng nhập",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFB99B6B)),
                                )),
                            SizedBox(
                              height: 32,
                            ),
                            EmailTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false),
                            SizedBox(
                              height: 32,
                            ),
                            PasswordTextField(
                                controller: passwordController,
                                hintText: "Nhập mật khẩu",
                                obscure: _isObsecured),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: signInUser,
                                child: const Text('Quên mật khẩu ?',
                                    style: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
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
                                  onPressed: signInUser,
                                  child: Text(
                                    "Đăng Nhập",
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
                                        builder: (context) => const SignUp()),
                                  );
                                },
                                child: const Text('Tạo tài khoản',
                                    style: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    )),
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
