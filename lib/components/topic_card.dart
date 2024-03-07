// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicCard extends StatefulWidget {
  final String topicName;
  final int numOfVocab;
  final Function()? onTap;

  const TopicCard(
      {super.key,
      required this.topicName,
      required this.numOfVocab,
      this.onTap});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 4),
      child: Card(
        elevation: 0,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          onTap: widget.onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 15, top: 10, bottom: 10),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.creamy,
                    ),
                    child: Center(
                      child: Container(
                        width: 25, // Adjusted width of the inner container
                        height: 25, // Adjusted height of the inner container
                        decoration: BoxDecoration(
                          // Ensure the inner container is also a circle
                          image: DecorationImage(
                            image: AssetImage('assets/list.png'),
                            fit: BoxFit
                                .contain, // You can use different BoxFit values based on your requirement
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.topicName,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cookie,
                  )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text('${widget.numOfVocab} từ',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.cookie,
                          ),
                        )),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: AppColors.cookie,
                    weight: 600.0,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
