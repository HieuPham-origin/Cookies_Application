// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:developer';
import 'dart:typed_data';
import 'package:cookie_app/components/setting_options.dart';
import 'package:cookie_app/pages/information_page.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserService userService = UserService(FirebaseAuth.instance.currentUser!);

  User user = FirebaseAuth.instance.currentUser!;
  Uint8List? _image;

  String? displayName =
      FirebaseAuth.instance.currentUser!.displayName ?? 'cookieuser';

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void loadProfileImage() async {
    _image = await userService.getProfileImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Thông tin",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: double.infinity,
              height: 120,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                surfaceTintColor: Colors.white,
                child: InkWell(
                  onTap: () async {
                    Route route = MaterialPageRoute(
                        builder: (context) => InformationPage());
                    final rollback = await Navigator.push(context, route);
                    setState(
                      () {
                        if (rollback[0] != "") {
                          displayName = rollback[0];
                        }

                        if (rollback[1] != null) {
                          _image = rollback[1];
                        }
                      },
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayName!,
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${user.email}",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, color: Color(0xFF9A9A9A))),
                          ),
                        ],
                      ),
                      _image != null
                          ? CircleAvatar(
                              radius: 50.0,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/logo.png'),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "Cài đặt",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 500,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                surfaceTintColor: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SettingOption(
                          title: "Thông báo",
                          icon: CupertinoIcons.app_badge_fill),
                    ),
                    InkWell(
                      onTap: () {},
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SettingOption(
                          title: "Ngôn ngữ", icon: CupertinoIcons.globe),
                    ),
                    InkWell(
                      onTap: () {},
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SettingOption(
                          title: "Thông báo",
                          icon: CupertinoIcons.app_badge_fill),
                    ),
                    InkWell(
                      onTap: signUserOut,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SettingOption(
                          title: "Đăng xuất", icon: Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
