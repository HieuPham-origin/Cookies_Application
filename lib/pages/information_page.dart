import 'package:cookie_app/components/edit_username_textfield.dart';
import 'package:cookie_app/components/password_textfield.dart';
import 'package:cookie_app/components/setting_options.dart';
import 'package:cookie_app/pages/change_name.dart';
import 'package:cookie_app/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/edit_password_textfield.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  UserService userService = UserService(FirebaseAuth.instance.currentUser!);
  
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String email ='';
  String displayName = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final userInfo = await userService.getUserInfo();
    setState(() {
    
      email = userInfo["emailAddress"];
      displayName = userInfo["displayName"];
      usernameController.text = displayName;
      emailController.text = email;
    });
  }

  Future<void> clickToChangePage() async {
    Route route = MaterialPageRoute(builder: (context) => ChangeName());
    final rollback = await Navigator.push(context, route);
    setState(() {
      displayName = rollback;
      usernameController.text = rollback;
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
              Navigator.pop(context,displayName);
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
                              textEditingController: emailController, content: email, hintText: "Email",icon: Icons.edit, colorIcon: Colors.green, 
                            onPressed: clickToChangePage,),
                            CustomTextField(
                            textEditingController: usernameController, content: displayName, hintText: "Nhập tên của bạn.", 
                            icon: Icons.edit, colorIcon: Colors.green, 
                            onPressed: clickToChangePage,
                            ),
                          EditPasswordTextField(
                            controller: passwordController, secret: "00000000", hintText: "Mật khẩu", obsucre: true,),
                          
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
                            backgroundImage: AssetImage("assets/logo.png"),
                          ),
                          FractionalTranslation(
                            translation: Offset(0.5, 1.3),
                            child: RawMaterialButton(
                              onPressed: () {},
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
