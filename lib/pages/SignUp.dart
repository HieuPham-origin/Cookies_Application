// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/pages/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _isObsecured;

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
                              height: 32,
                            ),
                            Text("Đăng ký",
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFB99B6B)),
                                )),
                            SizedBox(
                              height: 32,
                            ),

                            //Email field
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: TextField(
                                style: GoogleFonts.inter(),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFB99B6B)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFFB99B6B),
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    )),
                              ),
                            ),

                            SizedBox(
                              height: 32,
                            ),

                            //Password field
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: TextField(
                                style: GoogleFonts.inter(),
                                obscureText: _isObsecured,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFB99B6B)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    labelText: "Mật khẩu",
                                    labelStyle: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObsecured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFF9A9A9A),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObsecured = !_isObsecured;
                                        });
                                      },
                                    )),
                              ),
                            ),

                            SizedBox(
                              height: 32,
                            ),

                            //Confirm Password field
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: TextField(
                                style: GoogleFonts.inter(),
                                obscureText: _isObsecured,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Color(0xFFB99B6B)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    labelText: "Xác nhận mật khẩu",
                                    labelStyle: TextStyle(
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObsecured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFF9A9A9A),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObsecured = !_isObsecured;
                                        });
                                      },
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 32,
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
                                  onPressed: () {},
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
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Đã có tài khoản',
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
