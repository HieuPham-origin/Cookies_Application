import 'package:cookie_app/pages/practice_pages/quiz_screen.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/material.dart';

void showPracticeptionModalBottomSheet(BuildContext contextDetailTopic,
    String topicId, Map<String, dynamic> data) {
  var screenSize = MediaQuery.of(contextDetailTopic).size;

  Widget _buildOption(String title, String image, Function() onTap) {
    return Container(
      height: Dimensions.height(contextDetailTopic, 70),
      width: screenSize.width * 0.85,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimensions.width(contextDetailTopic, 75),
                ),
                Image.asset(
                  image,
                  width: 30, // Adjust width as needed
                  height: 30, // Adjust height as needed
                ),
                SizedBox(
                  width: Dimensions.width(contextDetailTopic, 20),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.icon_grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  showModalBottomSheet(
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: contextDetailTopic,
    builder: (BuildContext context) {
      return SizedBox(
        height: screenSize.height * 0.35,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.height(context, 40),
            ),
            _buildOption("Flashcards", "assets/flashcard.png", () {
              Navigator.pop(context);
              Navigator.of(contextDetailTopic).push(
                MaterialPageRoute(
                  builder: (contextDetailTopic) => SwipeCard(topidId: topicId),
                ),
              );
              // Navigator.of(context).pop();
            }),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            _buildOption("Trắc nghiệm", "assets/quiz.png", () {
              Navigator.pop(context);

              Navigator.of(contextDetailTopic).push(
                MaterialPageRoute(
                  builder: (contextDetailTopic) =>
                      QuizScreen(data: data, topicId: topicId),
                ),
              );
            }),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            _buildOption("Đánh vần", "assets/spell_check.png", () {}),
          ],
        ),
      );
    },
  );
}
