import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/folder_card.dart';
import 'package:cookie_app/models/topic.dart';
import 'package:cookie_app/pages/library_page/favorite_vocabularies_page.dart';
import 'package:cookie_app/pages/library_page/folder_page.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/material.dart';

void addTopicToFolder(String folderId, String topicId, Topic topic) async {
  try {
    await folderService.addTopicToFolder(folderId, topic, topicId, {
      'color': topic.color,
      'topicName': topic.topicName,
      'isPublic': topic.isPublic,
      'userId': topic.userId,
      'userEmail': topic.userEmail,
    });
    await topicService.deleteTopic(topicId);
  } catch (e) {
    // Optionally, show an error toast or dialog
  }
}

TopicService topicService = TopicService();

showFolderModalBottomSheet(BuildContext contextDetailTopic, String topicId,
    Topic topic, dynamic Function(int) setNumOfTopic, int numOfTopic) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    useRootNavigator: true,
    isDismissible: false,
    context: contextDetailTopic,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          expand: false,
          shouldCloseOnMinExtent: true,
          initialChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(contextDetailTopic).pop();
                        },
                        child: Text(
                          "Hủy",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.cookie,
                          ),
                        ),
                      ),
                      Text(
                        "Thêm vào thư mục",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cookie,
                        ),
                      ),
                      InkWell(
                        onTap: () async {},
                        child: Text("         "),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: folderService.getAll(),
                      builder: (BuildContext contextFolder,
                          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                        if (snapshot.hasData) {
                          List folder = snapshot.data!.docs;

                          return Wrap(
                            spacing: Dimensions.width(
                                contextFolder, 30), // adjust spacing as needed
                            runSpacing:
                                20, // adjust spacing between rows as needed
                            children: List.generate(
                              folder.length,
                              (index) {
                                DocumentSnapshot folderData = folder[index];
                                String folderName = folderData['folderName'];
                                // You can also retrieve other properties as needed

                                return FolderCard(
                                  folderName: folderName,
                                  numOfTopic: 0,
                                  onTap: () {
                                    addTopicToFolder(
                                        folderData.id, topicId, topic);
                                    setNumOfTopic(numOfTopic - 1);

                                    Navigator.of(contextFolder).pop();
                                    Navigator.of(contextDetailTopic).pop();
                                  },
                                  onTapDelete: () {
                                    folderService.deleteFolder(folderData.id);
                                  },
                                  type: 2,
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator(); // Or any loading indicator
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          });
    },
  );
}
