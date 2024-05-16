import 'dart:io';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cookie_app/components/custom_textfield.dart';
import 'package:cookie_app/components/modal_bottom_sheet/image_option.dart';
import 'package:cookie_app/models/community.dart';
import 'package:cookie_app/pages/change_name.dart';
import 'package:cookie_app/pages/change_password.dart';
import 'package:cookie_app/resources/store_data.dart';
import 'package:cookie_app/services/CommunityService.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:cookie_app/utils/constants.dart';
import 'package:cookie_app/utils/pick_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  UserService userService = UserService(FirebaseAuth.instance.currentUser!);
  CommunityService communityService = CommunityService();

  User? user = FirebaseAuth.instance.currentUser!;
  File? avatar;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String email = '';
  String displayName = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    loadAvatar();
  }

  // Load avatar from storage
  Future<void> loadAvatar() async {
    if (AppConstants.avatarUrl != null)
      return; // Ensure the avatar URL is loaded only once

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('avatars');
    Reference referenceChildDirImages = referenceDirImages.child(user!.uid);
    Reference referenceImageToUpload = referenceChildDirImages.child("avatar");

    try {
      final url = await referenceImageToUpload.getDownloadURL();
      setState(() {
        AppConstants.avatarUrl = url;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      email = user!.email!;
      displayName = user!.displayName ?? 'cookieuser';
      usernameController.text = displayName;
      emailController.text = email;
      passwordController.text = "password";
    });
  }

  Future<void> clickToChangeNamePage() async {
    Route route = MaterialPageRoute(
      builder: (context) => ChangeName(),
    );
    final rollback = await Navigator.push(context, route);
    setState(() {
      displayName = rollback;
      usernameController.text = rollback;
    });
  }

  Future<void> clickToChangePasswordPage() async {
    Route route = MaterialPageRoute(
      builder: (context) => ChangePassword(),
    );
    final rollback = await Navigator.push(context, route);
    setState(() {
      password = rollback;
      passwordController.text = rollback;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 24,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, [displayName, AppConstants.image]);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          "Thông tin",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 72,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 72, bottom: 32),
                      child: Column(
                        children: [
                          CustomTextField(
                            textEditingController: emailController,
                            content: email,
                            hintText: "Email",
                            obscured: false,
                            isEnable: false,
                            onPressed: clickToChangeNamePage,
                          ),
                          CustomTextField(
                            textEditingController: usernameController,
                            content: displayName,
                            hintText: "Tên hiển thị",
                            obscured: false,
                            isEnable: true,
                            icon: Icons.edit,
                            colorIcon: Colors.lightGreen,
                            onPressed: clickToChangeNamePage,
                          ),
                          CustomTextField(
                            textEditingController: passwordController,
                            content: password,
                            hintText: "Mật khẩu",
                            obscured: true,
                            isEnable: true,
                            icon: Icons.edit,
                            colorIcon: Colors.lightGreen,
                            onPressed: clickToChangePasswordPage,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                FractionalTranslation(
                  translation: Offset(0.0, -0.5),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.black12,
                              spreadRadius: 5)
                        ],
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AppConstants.avatarUrl != ""
                                ? NetworkImage(AppConstants.avatarUrl!)
                                : NetworkImage(
                                        "https://cdn.discordapp.com/attachments/1049968383082373191/1239879020414238844/logo.png?ex=664486d2&is=66433552&hm=64d4af042d201ef1982c7b048c362dcc2b68863cb21699556e21c13b27696415&")
                                    as ImageProvider,
                          ),
                          FractionalTranslation(
                            translation: Offset(0.5, 1.3),
                            child: RawMaterialButton(
                              onPressed: () {
                                showImageOptionModalBottomSheet(context,
                                    (File? newAvatar) async {
                                  if (newAvatar != null) {
                                    setState(() {
                                      avatar = newAvatar;
                                    });
                                    Reference referenceRoot =
                                        FirebaseStorage.instance.ref();
                                    Reference referenceDirImages =
                                        referenceRoot.child('avatars');
                                    Reference referenceChildDirImages =
                                        referenceDirImages.child(user!.uid);
                                    Reference referenceImageToUpload =
                                        referenceChildDirImages.child("avatar");
                                    try {
                                      await referenceImageToUpload
                                          .putFile(avatar!);
                                      final url = await referenceImageToUpload
                                          .getDownloadURL();

                                      setState(() {
                                        AppConstants.avatarUrl = url;
                                      });
                                      Navigator.pop(
                                          context, AppConstants.avatarUrl);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  }
                                });
                              },
                              elevation: 2.0,
                              fillColor: Color(0xFFF5F6F9),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.lightGreen,
                              ),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
