import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Trang chủ",
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ))),
          ),
        ],
      ),
    );
  }
}
