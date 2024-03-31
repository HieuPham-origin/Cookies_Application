import 'package:cookie_app/pages/practice_pages/swipe_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DetailTopic extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docID;
  const DetailTopic({
    super.key,
    required this.data,
    required this.docID,
  });
  @override
  State<DetailTopic> createState() => _DetailTopicState();
}

String edit = "Sửa";
final topicService = TopicService();
int numOfWord = -1;

class _DetailTopicState extends State<DetailTopic> {
  @override
  void initState() {
    super.initState();
    // Add your initialization logic here
    // For example, you can initialize data, fetch data from a service, etc.
    numOfWord = -1;
    topicService.countWordsInTopic(widget.docID).then((value) {
      setState(() {
        numOfWord = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context, 42)),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Container(
              color: AppColors.grey_light,
              height: 0.2,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Topic",
            style: TextStyle(
              color: AppColors.grey_heavy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 0, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.grey_heavy),
                  onPressed: () {
                    // Add your onPressed action here
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Add your onPressed action here
                        HapticFeedback.vibrate();
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.vibrate();
                      },
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: const Text(
                          "Sửa",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.icon_grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: numOfWord == -1
          ? Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: const CircularProgressIndicator(
                  backgroundColor: AppColors.background,
                  strokeCap: StrokeCap.round,
                  color: AppColors.cookie,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10.0),
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.data['topicName'],
                              style: TextStyle(
                                fontSize: Dimensions.fontSize(context, 24),
                                fontWeight: FontWeight.w500,
                                color: AppColors.cookie,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.creamy,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${numOfWord} từ",
                              style: TextStyle(
                                fontSize: Dimensions.fontSize(context, 16),
                                color: AppColors.cookie,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SwipeCard(
                              topidId: widget.docID,
                            ),
                          ),
                        ),
                        child: const Text("Flashcard"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
