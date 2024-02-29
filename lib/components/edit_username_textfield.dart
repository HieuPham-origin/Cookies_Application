import 'package:cookie_app/pages/change_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class EditUsernameTextField extends StatefulWidget {
  final controller;
  final String hintText;

  const EditUsernameTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  State<EditUsernameTextField> createState() => _EditUsernameTextFieldState();
}

class _EditUsernameTextFieldState extends State<EditUsernameTextField> {
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
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB99B6B), width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            labelText: widget.hintText,
            labelStyle: const TextStyle(
              color: Color(0xFF9A9A9A),
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.lightGreen,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => ChangeName());
                Navigator.push(context, route);
              },
            )),
      ),
    );
  }
}
