// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Thông tin",
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ))),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lâm Hoàng Hiếu",
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
                          "52100069@student.tdtu.edu.vn",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 12, color: Color(0xFF9A9A9A))),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),
                    )
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
