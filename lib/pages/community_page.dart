import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Cộng đồng",
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ))),
          ),
        ],
      ),
    );  }
}