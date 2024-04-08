// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderCard extends StatefulWidget {
  final String folderName;
  final int numOfTopic;
  final Function()? onTap;

  const FolderCard(
      {super.key,
      required this.folderName,
      required this.numOfTopic,
      this.onTap});

  @override
  State<FolderCard> createState() => FolderCardState();
}

class FolderCardState extends State<FolderCard> {
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
                    child: Icon(
                      CupertinoIcons.folder,
                      color: AppColors.cookie,
                      size: 20,
                    ),
                    decoration: BoxDecoration(
                        // Ensure the inner container is also a circle
                        // image: DecorationImage(
                        //   image: AssetImage('assets/list.png'),
                        //   fit: BoxFit
                        //       .contain, // You can use different BoxFit values based on your requirement
                        // ),

                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.folderName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cookie,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text('${widget.numOfTopic} topics',
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
