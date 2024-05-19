// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer' as developer;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/word.dart';
import 'package:cookie_app/services/WordService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WordService wordService = WordService();
  String randomWord = "";
  String phonetic = "";
  List<Word> words = [];
  int index = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final audioPlayer = AudioPlayer();

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getAllWords().then((fetchedWord) {
      setState(() {
        words = fetchedWord;
        index = randomIndexInWords();
      });
    });
  }

  //function to fetch word
  Future<List<Word>> getAllWords() async {
    QuerySnapshot querySnapshot = await _firestore.collection('words').get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    for (var doc in docs) {
      words.add(Word(
        word: doc['word'],
        definition: doc['definition'],
        phonetic: doc['phonetic'],
        date: doc['date'],
        image: doc['image'],
        wordForm: doc['wordForm'],
        example: doc['example'],
        audio: doc['audio'],
        isFav: doc['isFav'],
        topicId: doc['topicId'],
        status: doc['status'],
        userId: doc['userId'],
      ));
    }

    return words;
  }

  int randomIndexInWords() {
    Random random = Random();
    return random.nextInt(words.length);
  }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: words.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                                      words[index].word,
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
                                      words[index].phonetic,
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
                                  await audioPlayer.stop();
                                  await audioPlayer.play(UrlSource(
                                      "https://cp.tdung.co/?url=" +
                                          Uri.encodeComponent(
                                              words[index].audio)));
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
                            child: Text(
                              words[index].definition,
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
                            child: Text(
                              words[index].example,
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
                          Container(
                            height: 40,
                            width: Dimensions.width(
                                context, MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  AppColors.cookie,
                                  Color.fromARGB(204, 185, 155, 107),
                                ])),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(200, 40),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                wordService.addWord(Word(
                                  word: words[index].word,
                                  definition: words[index].definition,
                                  phonetic: words[index].phonetic,
                                  date: words[index].date,
                                  image: words[index].image,
                                  wordForm: words[index].wordForm,
                                  example: words[index].example,
                                  audio: words[index].audio,
                                  isFav: words[index].isFav,
                                  topicId: words[index].topicId,
                                  status: words[index].status,
                                  userId: currentUser!.uid,
                                ));
                              },
                              child: const Text("Lưu vào thư viện"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Image.network(
                              'https://ichef.bbc.co.uk/images/ic/640x360/p0hv93qp.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await _launchInBrowserView(Uri.parse(
                            "https://www.bbc.co.uk/learningenglish/english/features/real-easy-english/240517"));
                      },
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
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              )),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
