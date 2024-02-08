import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const EmailTextField({
      super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(),
        obscureText: obscureText,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFB99B6B)),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color(0xFFB99B6B), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            labelText: hintText,
            labelStyle: const TextStyle(
              color: Color(0xFF9A9A9A),
            )),
      ),
    );
  }
}
