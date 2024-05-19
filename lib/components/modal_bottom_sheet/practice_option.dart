import 'dart:developer';

import 'package:cookie_app/pages/practice_pages/quiz_screen.dart';
import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/pages/practice_pages/type_practice_screen.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/material.dart';
import 'package:toasty_box/toasty_box.dart';

void showPracticeptionModalBottomSheet(
    BuildContext contextDetailTopic, String topicId, Map<String, dynamic> data,
    {int? type, String? communityId}) {
  var screenSize = MediaQuery.of(contextDetailTopic).size;

  Widget _buildOption(String title, String image, Function() onTap) {
    TopicService topicService = TopicService();

    return Container(
      height: Dimensions.height(contextDetailTopic, 70),
      width: screenSize.width * 0.85,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () async {
            int wordCount = await topicService.countWordsInTopic(topicId);
            wordCount >= 5
                ? onTap()
                : ToastService.showWarningToast(
                    contextDetailTopic,
                    message: "Topic cần tối thiểu 5 từ vựng",
                  );
          },
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Dimensions.width(contextDetailTopic, 75),
              ),
              Image.asset(
                image,
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: Dimensions.width(contextDetailTopic, 20),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.icon_grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
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
            type != 1
                ? _buildOption("Flashcards", "assets/flashcard.png", () {
                    Navigator.pop(context);
                    Navigator.of(contextDetailTopic).push(
                      MaterialPageRoute(
                        builder: (contextDetailTopic) =>
                            SwipeCard(topidId: topicId),
                      ),
                    );
                  })
                : Container(),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            _buildOption("Trắc nghiệm", "assets/quiz.png", () {
              Navigator.pop(context);

              Navigator.of(contextDetailTopic).push(
                MaterialPageRoute(
                  builder: (contextDetailTopic) => QuizScreen(
                    data: data,
                    topicId: topicId,
                    communityId: communityId,
                    type: type ?? 0,
                  ),
                ),
              );
            }),
            SizedBox(
              height: Dimensions.height(context, 10),
            ),
            _buildOption("Điền từ", "assets/spell_check.png", () {
              Navigator.pop(context);
              Navigator.of(contextDetailTopic).push(
                MaterialPageRoute(
                  builder: (contextDetailTopic) => TypePracticeScreen(
                    data: data,
                    topicId: topicId,
                    communityId: communityId,
                    type: 1,
                  ),
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}
