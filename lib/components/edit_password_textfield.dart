import 'package:cookie_app/pages/change_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;

  EditPasswordTextField({
      super.key,
      required this.controller,
      required this.hintText
    });

  @override
  State<EditPasswordTextField> createState() => _EditPasswordTextFieldState();
}

class _EditPasswordTextFieldState extends State<EditPasswordTextField> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextField(
        controller: widget.controller,
        style: GoogleFonts.inter(),
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
              icon: const Icon(
                Icons.edit,
                color: Colors.lightGreen,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => ChangePassword());
                Navigator.push(context, route);
              },
            )),
      ),
    );
  }
}
