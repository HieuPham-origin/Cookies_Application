import 'package:cookie_app/pages/change_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String content;
  final String hintText;
  final IconData? icon;
  final Color? colorIcon;
  final VoidCallback? onPressed;
  const CustomTextField(
      {super.key, required this.textEditingController, required this.content, required this.hintText, 
      this.icon, this.colorIcon, this.onPressed});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32),
      child: TextField(
        controller: widget.textEditingController,
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
          suffixIcon: IconButton(
            icon: Icon(
              widget.icon,
              color: widget.colorIcon,
            ),
            onPressed:
              widget.onPressed
          ),
        ),
      ),
    );
  }
}