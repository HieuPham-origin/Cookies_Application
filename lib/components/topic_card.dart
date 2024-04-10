// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicCard extends StatefulWidget {
  final String topicName;
  final int numOfVocab;
  final Function()? onTap;
  final String color;

  const TopicCard(
      {super.key,
      required this.topicName,
      required this.numOfVocab,
      this.onTap,
      required this.color});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  Color getColor() {
    switch (widget.color) {
      case 'red':
        return AppColors.red;
      case 'green':
        return AppColors.green;
      case 'blue':
        return AppColors.blue;
      case 'yellow':
        return AppColors.yellow;
      case 'orange':
        return AppColors.orange;
      case 'grey':
        return AppColors.icon_grey;
      case 'purple':
        return AppColors.purple;
      default:
        return AppColors.cookie;
    }
  }

  Color getBackgroundColor() {
    switch (widget.color) {
      case 'red':
        return Colors.pinkAccent.withOpacity(0.1);
      case 'green':
        return Colors.greenAccent.withOpacity(0.1);
      case 'blue':
        return Colors.blueAccent.withOpacity(0.08);
      case 'yellow':
        return AppColors.yellow.withOpacity(0.1);
      case 'orange':
        return Colors.orangeAccent.withOpacity(0.1);
      case 'grey':
        return AppColors.grey_light.withOpacity(0.1);
      case 'purple':
        return AppColors.purple.withOpacity(0.1);
      default:
        return AppColors.creamy;
    }
  }

  AssetImage getImageAsset() {
    switch (widget.color) {
      case 'red':
        return AssetImage('assets/list_red.png');
      case 'green':
        return AssetImage('assets/list_green.png');
      case 'blue':
        return AssetImage('assets/list_blue.png');
      case 'yellow':
        return AssetImage('assets/list_yellow.png');
      case 'orange':
        return AssetImage('assets/list_orange.png');
      case 'grey':
        return AssetImage('assets/list_grey.png');
      case 'purple':
        return AssetImage('assets/list_purple.png');
      default:
        return AssetImage('assets/list.png');
    }
  }

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
                  color: getBackgroundColor(),
                ),
                child: Center(
                  child: Container(
                    width: 25, // Adjusted width of the inner container
                    height: 25, // Adjusted height of the inner container
                    decoration: BoxDecoration(
                      // Ensure the inner container is also a circle
                      image: DecorationImage(
                        image: getImageAsset(),
                        fit: BoxFit
                            .contain, // You can use different BoxFit values based on your requirement
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.topicName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: getColor(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('${widget.numOfVocab} từ',
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: getColor(),
                      ),
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
