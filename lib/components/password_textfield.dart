import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;
  bool obscure;

  PasswordTextField({
      super.key,
      required this.controller,
      required this.hintText,
      required this.obscure
    });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextField(
        controller: widget.controller,
        style: GoogleFonts.inter(),
        obscureText: widget.obscure,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFB99B6B)),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            labelText: widget.hintText,
            labelStyle: const TextStyle(
              color: Color(0xFF9A9A9A),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                widget.obscure ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF9A9A9A),
              ),
              onPressed: () {
                setState(() {
                  widget.obscure = !widget.obscure;
                });
              },
            )),
      ),
    );
  }
}
