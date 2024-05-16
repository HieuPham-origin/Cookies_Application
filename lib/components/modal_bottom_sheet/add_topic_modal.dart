import 'dart:developer';

import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

void showAddTopicModalBottomSheet(
    BuildContext context,
    TextEditingController topicController,
    User user,
    TopicService topicService,
    void setState(void Function() fn),
    Function(String) setTopicName,
    Function(String)? setColor,
    Function(int) setNumOfTopic,
    int numOfTopic,
    String topicId,
    int type
    // Assuming this is a dependency
    ) {
  bool isLoading = false;
  String color_changed = "default";
  if (type == 1) {
    topicController.text = "";
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    backgroundColor: Colors.white,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.header_background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: !isLoading
                      ? () async {
                          // Remove focus from any text fields to hide the keyboard
                          FocusScope.of(context).unfocus();

                          // Wait for a short duration to ensure the keyboard dismiss animation can complete
                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          // Then, navigate back to the previous screen
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text(
                    "Hủy",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.cookie,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  type == 1 ? "Tạo Topic" : "Sửa Topic",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.cookie,
                  ),
                ),
                InkWell(
                    onTap: () async {
                      if (type == 1) {
                        if (topicController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await topicService.addTopic(Topic(
                              topicName: topicController.text,
                              isPublic: false,
                              userId: user.uid,
                              userEmail: user.email,
                              color: color_changed == "default"
                                  ? "default"
                                  : color_changed,
                            ));
                            FocusScope.of(context).unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setNumOfTopic(numOfTopic + 1);
                            Navigator.of(context).pop();
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      } else {
                        if (topicController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await topicService.updateTopic(
                                topicId,
                                Topic(
                                  topicName: topicController.text,
                                  isPublic: false,
                                  userId: user.uid,
                                  userEmail: user.email,
                                  color: color_changed == "default"
                                      ? "default"
                                      : color_changed,
                                ));
                            FocusScope.of(context).unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setTopicName(topicController.text);
                            setColor!(color_changed);
                            Navigator.of(context).pop();
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }
                    },
                    child: Container(
                      width: Dimensions.width(
                          context, 40), // Adjust width according to your needs
                      height: 24, // Adjust height according to your needs
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible: isLoading,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.cookie),
                            ),
                          ),
                          Visibility(
                            visible: !isLoading,
                            child: Text(
                              "Tiếp",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.cookie,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: topicController,
                  autofocus: true,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                  ),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 0),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.cookie),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    "TOPIC",
                    style: TextStyle(
                      color: AppColors.grey_light,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ColorPicker(
            color: color_changed == "default"
                ? AppColors.cookie
                : color_changed == "red"
                    ? AppColors.red_list
                    : color_changed == "green"
                        ? AppColors.green_list
                        : color_changed == "blue"
                            ? AppColors.blue_list
                            : color_changed == "yellow"
                                ? AppColors.yellow_list
                                : color_changed == "orange"
                                    ? AppColors.orange_list
                                    : color_changed == "grey"
                                        ? AppColors.grey_list
                                        : color_changed == "purple"
                                            ? AppColors.purple_list
                                            : AppColors.cookie,
            borderRadius: 50,
            height: Dimensions.height(context, 36),
            width: Dimensions.width(context, 36),
            enableShadesSelection: false,
            spacing: 8,
            customColorSwatchesAndNames: {
              AppColors.cookie_list: 'Cookie',
              AppColors.red_list: 'Red',
              AppColors.green_list: 'Green',
              AppColors.blue_list: 'Blue',
              AppColors.yellow_list: 'Yellow',
              AppColors.orange_list: 'Orange',
              AppColors.grey_list: 'Grey',
              AppColors.purple_list: 'Purple',
            },
            selectedColorIcon: Icons.check,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.wheel: false,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: true,
              ColorPickerType.primary: false,
            },
            onColorChanged: (Color color) {
              setState(() {
                if (color.value == AppColors.red_list.value) {
                  color_changed = "red";
                } else if (color.value == AppColors.green_list.value) {
                  color_changed = "green";
                } else if (color.value == AppColors.blue_list.value) {
                  color_changed = "blue";
                } else if (color.value == AppColors.yellow_list.value) {
                  color_changed = "yellow";
                } else if (color.value == AppColors.orange_list.value) {
                  color_changed = "orange";
                } else if (color.value == AppColors.grey_list.value) {
                  color_changed = "grey";
                } else if (color.value == AppColors.purple_list.value) {
                  color_changed = "purple";
                } else if (color.value == AppColors.cookie_list.value) {
                  color_changed = "default";
                } else {
                  color_changed = "default";
                }
              });
              print(color_changed);
            },
          )
        ],
      ),
    ),
  );
}
