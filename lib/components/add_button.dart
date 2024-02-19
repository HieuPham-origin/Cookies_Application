// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final IconData icon;
  const AddButton({super.key, this.onPressed, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFCF7E3), elevation: 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF8F6D21))),
                ),
                SizedBox(
                  width: 10,
                ),
               Icon(
                  icon,
                  color: Colors.red,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
