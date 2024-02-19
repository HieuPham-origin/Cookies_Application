// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingOption extends StatelessWidget {
  final String title;
  final IconData icon;

  const SettingOption({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
       Padding(
        padding: EdgeInsets.only(left: 8.0, top: 10),
        child: Icon(
          icon,
          color: Colors.green,
          size: 32,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              const Divider(
                color: Color.fromARGB(255, 115, 86, 86),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
