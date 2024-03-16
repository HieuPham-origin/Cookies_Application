import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:toasty_box/toast_service.dart';

class SwipeCard extends StatefulWidget {
  const SwipeCard({super.key});

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  @override
  void initState() {
    super.initState();
  }

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
            ],
          ),
          Container(
            padding: EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            child: AppinioSwiper(
              backgroundCardCount: 1,
              cardCount: 10,
              swipeOptions: const SwipeOptions.only(left: true, right: true),
              cardBuilder: (BuildContext context, int index) {
                return FlipCard(
                  speed: 350,
                  front: Card(
                    elevation: 4,
                    shadowColor: Colors.black,
                    surfaceTintColor: Colors.white,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Family",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "/pha my ly/",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                  back: Card(
                    elevation: 4,
                    shadowColor: Colors.black,
                    surfaceTintColor: Colors.green,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Family",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "/pha my ly/",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
