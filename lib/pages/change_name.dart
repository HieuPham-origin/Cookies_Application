import 'package:cookie_app/components/edit_username_textfield.dart';
import 'package:cookie_app/components/password_textfield.dart';
import 'package:cookie_app/components/setting_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/edit_password_textfield.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  State<ChangeName> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeName> {
  final user = FirebaseAuth.instance.currentUser!;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
            icon: Icon(
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
          SizedBox(
            height: 72,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 64),
                      child: Column(
                        children: [
                          Text(
                            "Đổi tên",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Bạn có thể đổi thành tên khác",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF9A9A9A)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          EditUsernameTextField(
                            controller: usernameController, hintText: "Tên"),
                          SizedBox(
                            height: 32,
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
                                  onPressed: () {},
                                  child: Text(
                                    "Thay đổi",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
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
                  ),
                ),
                FractionalTranslation(
                  translation: Offset(0.0, -0.5),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.black12,
                              spreadRadius: 5)
                        ],
                      ),
                      // child: Stack(
                      //   children: [
                      //     // CircleAvatar(
                      //     //   radius: 50.0,
                      //     //   backgroundImage: AssetImage("assets/logo.png"),
                      //     // ),
                      //     FractionalTranslation(
                      //       translation: Offset(0.5, 1.3),
                      //       child: RawMaterialButton(
                      //         onPressed: () {},
                      //         elevation: 2.0,
                      //         fillColor: Color(0xFFF5F6F9),
                      //         child: Icon(
                      //           Icons.camera_alt_outlined,
                      //           color: Colors.lightGreen,
                      //         ),
                      //         shape: CircleBorder(),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
