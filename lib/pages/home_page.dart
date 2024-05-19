// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cookie_app/components/custom_segment_button.dart';
import 'package:cookie_app/pages/library_page/detail_topic_page.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Dimensions.width(
                                      context, 250), // Adjust width as needed
                                  // Adjust height as needed
                                  child: Text(
                                    "wqwqwd",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize:
                                            Dimensions.fontSize(context, 24),
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.grey_heavy,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimensions.width(context, 250),
                                  child: Text(
                                    "noun /qwwq/",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        fontSize:
                                            Dimensions.fontSize(context, 16),
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.grey_heavy,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                // await audioPlayer.stop();
                                // await audioPlayer.play(UrlSource("https://cp.tdung.co/?url=" +
                                //             Uri.encodeComponent()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                    4), // Adjust padding as needed

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(
                                      0.6), // Adjust color and opacity as needed
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  size: 52, // Adjust icon size as needed
                                  color: AppColors
                                      .creamy, // Adjust icon color as needed
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Định nghĩa",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: Dimensions.fontSize(context, 14),
                              fontStyle: FontStyle.italic,
                              color: AppColors.grey_light,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          // child: TextField(
                          //   maxLines: null,
                          //   style: GoogleFonts.inter(
                          //     textStyle: TextStyle(
                          //       fontSize: Dimensions.fontSize(context, 18),
                          //       color: AppColors.grey_heavy,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          //   decoration: const InputDecoration(
                          //     isDense: true,
                          //     contentPadding: EdgeInsets.all(0),
                          //     border: InputBorder.none,
                          //     counterText: "",
                          //   ),
                          // ),
                          child: Text(
                            "A word is a unit of language that native speakers can agree upon as a separate and distinct unit of meaning. Words can be made up of a single morpheme or of more than one. In English, words can be classified as one of eight parts of speech. Words can be combined to create phrases, clauses, and sentences.",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: Dimensions.fontSize(context, 18),
                                color: AppColors.grey_heavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height(context, 12),
                        ),
                        Text(
                          "Ví dụ",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: Dimensions.fontSize(context, 14),
                              fontStyle: FontStyle.italic,
                              color: AppColors.grey_light,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          // child: TextField(
                          //   maxLines: null,
                          //   style: GoogleFonts.inter(
                          //     textStyle: TextStyle(
                          //       fontSize: Dimensions.fontSize(context, 18),
                          //       color: AppColors.grey_heavy,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          //   decoration: const InputDecoration(
                          //     isDense: true,
                          //     contentPadding: EdgeInsets.all(0),
                          //     border: InputBorder.none,
                          //     counterText: "",
                          //   ),
                          // ),
                          child: Text(
                            "A word is a unit of language that native speakers can agree upon as a separate and distinct unit of meaning. Words can be made up of a single morpheme or of more than one. In English, words can be classified as one of eight parts of speech. Words can be combined to create phrases, clauses, and sentences.",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: Dimensions.fontSize(context, 18),
                                color: AppColors.grey_heavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height(context, 22),
                        ),
                        SizedBox(
                          height: Dimensions.height(context, 42),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
