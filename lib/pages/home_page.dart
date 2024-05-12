import 'dart:developer';

import 'package:cookie_app/services/WordService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Trang chủ",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("random word"),
          ),
          Text("$randomWord"),
        ],
      ),
    );
  }
}
