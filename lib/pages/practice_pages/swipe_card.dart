import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class SwipeCard extends StatefulWidget {
  const SwipeCard({super.key});

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                leading: Text(
                  "1/10",
                  style: TextStyle(fontSize: 18),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 28,
                  ),
                ),
                lineHeight: 6.0,
                width: MediaQuery.of(context).size.width * 0.75,
                percent: 0.1,
                animation: true,
                animationDuration: 1000,
                backgroundColor: Colors.grey,
                barRadius: Radius.circular(20),
                progressColor: Colors.lightGreen,
              ),
              AppinioSwiper(
                cardBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text(index.toString()),
                    color: Colors.blue,
                  );
                },
                cardCount: 10,
              )
            ],
          ),
        ],
      ),
    );
  }
}
