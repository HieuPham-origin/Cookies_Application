import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/components/topic_card.dart';
import 'package:cookie_app/services/TopicService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WallPost extends StatefulWidget {
  final GlobalKey<WallPostState> key;

  const WallPost({required this.key}) : super(key: key);

  @override
  State<WallPost> createState() => WallPostState();
}

class WallPostState extends State<WallPost> with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  TextEditingController communityController = TextEditingController();
  TopicService topicService = TopicService();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String userImage = FirebaseAuth.instance.currentUser!.photoURL!;

  @override
  void initState() {
    super.initState();
    widget.key.currentState!.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DraggableScrollableSheet(
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
                  // type == 1 ? "Tạo Topic" : "Sửa Topic",
                  "Bài mới",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.cookie,
                  ),
                ),
                InkWell(
                    onTap: () async {},
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: Dimensions.width(context, 42),
                        height: Dimensions.height(context, 42),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                            image: AssetImage('assets/girl.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width(context, 10),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FirebaseAuth.instance.currentUser!.displayName!,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey_heavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              maxLines: null,
                              controller: communityController,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: Dimensions.fontSize(context, 18),
                                  color: AppColors.grey_heavy,
                                ),
                              ),
                              decoration: InputDecoration(
                                hintText: "Có gì mới?...",
                                hintStyle: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey_light,
                                  ),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: AppColors.grey_light,
                  thickness: 0.3,
                ),
              ],
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: topicService.getTopicsByUserId(userId),
                builder: (context, snapshot) {
                  List topics = snapshot.data!.docs;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                  if (topics.isEmpty) {
                    return const Center(
                      child: Text("No data"),
                    );
                  }

                  return ListView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      shrinkWrap: true,
                      itemCount: topics.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document = topics[index];
                        String docID = document.id;

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        // Topic's attributes
                        String topicTitle = data['topicName'];
                        String color = data['color'];
                        return FutureBuilder<int>(
                            future: topicService.countWordsInTopic(docID),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              int numOfVocabInTopicLibrary = snapshot.data ?? 0;

                              return TopicCard(
                                  topicName: topicTitle,
                                  numOfVocab: numOfVocabInTopicLibrary,
                                  color: color);
                            });
                      });
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
