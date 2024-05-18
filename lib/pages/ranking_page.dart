import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_app/models/ranking.dart';
import 'package:cookie_app/pages/detail_topic_for_community.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  String communityId;
  RankingPage({super.key, required this.communityId});

  @override
  State<RankingPage> createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage> {
  Map<String, List> dataTop3 = {};
  CommunityService communityService = CommunityService();
  List<Ranking> rankings = [];
  bool flag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> getAvatarUrl(String userId) async {
    Reference storage = FirebaseStorage.instance.ref();
    Reference referenceImageToUpload =
        storage.child('avatars').child(userId).child("avatar");

    try {
      final url = await referenceImageToUpload.getDownloadURL();
      return url;
    } catch (e) {
      log(e.toString());
      return "https://firebasestorage.googleapis.com/v0/b/cookieapp-46bb1.appspot.com/o/avatars%2Flogo.png?alt=media&token=d3d1ada3-9052-4a50-983f-23be14ca121f";
    }
  }

  // get all ranking
  Future<void> getAllRanking() async {
    if (flag) {
      return;
    }
    rankings.clear();
    final result =
        await communityService.getAllRankingOrderByPoint(widget.communityId);
    for (var doc in result.docs) {
      rankings.add(Ranking(
        userId: doc['userId'],
        email: doc['email'],
        point: doc['point'],
        topicId: doc['topicId'],
        avatar: await getAvatarUrl(doc['userId']),
      ));
    }
    if (rankings.length >= 3) {
      dataTop3 = {
        rankings[0].email: [
          rankings[0].point,
          rankings[0].avatar,
        ],
        rankings[1].email: [
          rankings[1].point,
          rankings[1].avatar,
        ],
        rankings[2].email: [
          rankings[2].point,
          rankings[2].avatar,
        ],
      };
    } else if (rankings.length == 2) {
      dataTop3 = {
        rankings[0].email: [
          rankings[0].point,
          rankings[0].avatar,
        ],
        rankings[1].email: [
          rankings[1].point,
          rankings[1].avatar,
        ],
      };
    } else if (rankings.length == 1) {
      dataTop3 = {
        rankings[0].email: [
          rankings[0].point,
          rankings[0].avatar,
        ],
      };
    }

    setState(() {
      flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(Icons.arrow_back_ios),
              Text(
                "Quay lại",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Bảng xếp hạng",
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Image.asset(
                  "assets/leaderboard.png",
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: getAllRanking(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (rankings.isEmpty) {
                    return const Center(
                      child: Text("Chưa có ai thực hiện bài tập nào"),
                    );
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: rankings.length,
                      itemBuilder: (context, index) {
                        if (rankings.isEmpty) {
                          return const Center(
                            child: Text("Không có dữ liệu"),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 15),
                          child: Row(
                            children: [
                              Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(rankings[index].avatar),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  rankings[index].email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 25,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.cookie,
                                      color: AppColors.cookie,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      rankings[index].point.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ),

          // Rank 1st
          if (dataTop3.isNotEmpty)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: rank(
                  radius: 45.0,
                  height: 10,
                  image: dataTop3.values.elementAt(0).elementAt(1),
                  name: dataTop3.keys.elementAt(0).replaceAll("@gmail.com", ""),
                  point: dataTop3.values.elementAt(0).elementAt(0).toString(),
                ),
              ),
            ),
          // for rank 2nd
          if (dataTop3.length > 1)
            Positioned(
              top: 120,
              left: 45,
              child: rank(
                radius: 30.0,
                height: 10,
                image: dataTop3.values.elementAt(1).elementAt(1),
                name: dataTop3.keys.elementAt(1).replaceAll("@gmail.com", ""),
                point: dataTop3.values.elementAt(1).elementAt(0).toString(),
              ),
            ),
          // For 3rd rank
          if (dataTop3.length > 2)
            Positioned(
              top: 140,
              right: 40,
              child: rank(
                radius: 30.0,
                height: 10,
                image: dataTop3.values.elementAt(2).elementAt(1),
                name: dataTop3.keys.elementAt(2).replaceAll("@gmail.com", ""),
                point: dataTop3.values.elementAt(2).elementAt(0).toString(),
              ),
            ),
        ],
      ),
    );
  }
}

Column rank({
  required double radius,
  required double height,
  required String image,
  required String name,
  required String point,
}) {
  return Column(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(image),
      ),
      SizedBox(
        height: height,
      ),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
      ),
      SizedBox(
        height: height,
      ),
      Container(
        height: 25,
        width: 70,
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.cookie,
              color: Color.fromARGB(255, 255, 187, 0),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              point,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}
