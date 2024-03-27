import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toast_service.dart';

void showAddTopicModalBottomSheet(
    BuildContext context,
    TextEditingController topicController,
    User user,
    TopicService topicService,
    bool _btnActive,
    void setState(void Function() fn)
    // Assuming this is a dependency
    ) {
  topicController.clear();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    backgroundColor: Colors.white,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightGreen),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: Center(
                        child: Text(
                      "Thêm Topic",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    child: IconButton(
                      icon: Icon(Icons.close, size: 28),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: topicController,
                  onChanged: (value) {
                    setState(() {
                      _btnActive = value.isNotEmpty ? true : false;
                    });
                  },
                  autofocus: true,
                  style: GoogleFonts.inter(),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cookie),
                    ),
                    label: Text("Tên Topic"),
                    floatingLabelStyle: TextStyle(
                      color: AppColors.cookie,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _btnActive == true
                      ? () async {
                          Topic topic = Topic(
                              topicName: topicController.text,
                              isPublic: false,
                              userId: user.uid,
                              userEmail: user.email);
                          try {
                            await topicService.addTopic(topic);
                            ToastService.showSuccessToast(context,
                                message: "Add topic thành công");
                            Navigator.pop(context);
                          } catch (e) {
                            print('Failed to add topic: $e');
                            // Optionally, show an error toast or dialog
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99B6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    "Thêm Topic",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
