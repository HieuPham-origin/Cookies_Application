import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Thư viện",
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
