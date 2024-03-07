import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEmailTextField extends StatefulWidget {
  final TextEditingController controller;
  final String content;
  final String hintText;

  const EditEmailTextField({
    Key? key,
    required this.controller,
    required this.content,
    required this.hintText,
  }) : super(key: key);

  @override
  State<EditEmailTextField> createState() => _EditEmailTextFieldState();
}

class _EditEmailTextFieldState extends State<EditEmailTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
      child: TextField(
        controller: widget.controller,
        style: GoogleFonts.inter(),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFFB99B6B)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB99B6B), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            color: Color(0xFF9A9A9A),
          ),
          
        ),
      ),
    );
  }
}