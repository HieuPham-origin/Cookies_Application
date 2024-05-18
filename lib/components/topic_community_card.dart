// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicCommunityCard extends StatefulWidget {
  final String? topicId;
  final String topicName;
  final int numOfVocab;
  final Function()? onTap;
  final String color;

  const TopicCommunityCard({
    super.key,
    required this.topicName,
    required this.numOfVocab,
    this.onTap,
    required this.color,
    this.topicId,
  });

  @override
  State<TopicCommunityCard> createState() => _TopicCommunityCardState();

  getColor() {}
}

class _TopicCommunityCardState extends State<TopicCommunityCard> {
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
        return Colors.yellowAccent.withOpacity(0.12);
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
    return Row(
      children: [
        Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: getColor(), width: 0.3),
          ),
          elevation: 0,
          surfaceTintColor: Colors.white,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                width: Dimensions.width(context, 42),
                height: Dimensions.height(context, 42),
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
              SizedBox(
                width: Dimensions.width(context, 10),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
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
                  Text('${widget.numOfVocab} từ',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: getColor(),
                        ),
                      )),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
