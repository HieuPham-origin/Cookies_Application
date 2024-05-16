// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WordService wordService = WordService();
  String randomWord = "";
  @override
  void initState() {
    super.initState();
    log(FirebaseAuth.instance.currentUser!.emailVerified.toString());
    fetchRandomWord().then((fetchedWord) {
      setState(() {
        randomWord = fetchedWord;
      });
    });
  }

  Future<String> fetchRandomWord() async {
    randomWord = await wordService.getRandomWord();
    return randomWord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Trang chủ",
      //     style: GoogleFonts.inter(
      //       textStyle: const TextStyle(
      //         fontSize: 28,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "austere",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "adjective /austere/",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: Container(
                      padding:
                          const EdgeInsets.all(4), // Adjust padding as needed

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(
                            0.6), // Adjust color and opacity as needed
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        size: 74, // Adjust icon size as needed
                        color: AppColors.creamy, // Adjust icon color as needed
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "definition",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "She has an austere style that has not changed in 16 years.",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "synonyms",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Text(
                        "plain",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Text(
                        "simple",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "translation",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "nghiêm túc, chất phát",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.black,
                        backgroundColor: Color(0xFFB99B6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Lưu từ vựng",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        16, 16, 16, 20), // Adjust padding as needed

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(
                          0.7), // Adjust color and opacity as needed
                    ),
                    child: const Icon(Icons.ios_share,
                        size: 36, // Adjust icon size as needed
                        color: Colors.white // Adjust icon color as needed
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: double.infinity,
                height: 500,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Image.network(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "Xem chi tiết",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
