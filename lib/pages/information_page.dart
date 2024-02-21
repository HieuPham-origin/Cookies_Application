import 'package:cookie_app/components/password_textfield.dart';
import 'package:cookie_app/components/setting_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:cookie_app/components/edit_email_textfield.dart';
import 'package:cookie_app/components/edit_password_textfield.dart';

class InformationPage extends StatefulWidget{
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {

  final user = FirebaseAuth.instance.currentUser!;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context){
    return Scaffold(
  body: Column(
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Thông tin 22",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 12,
      ),
      Expanded( // Wrap the Row with Expanded
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: double.infinity,
            height: 500,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              surfaceTintColor: Colors.white,
              child: InkWell(
                onTap: () => ToastService.showToast(context, message: "clicked"),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/logo.png'),
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     EditEmailTextField(
                    //       controller: emailController,
                    //       hintText: "Email",
                    //     ),
                    //     SizedBox(
                    //       height: 16,
                    //     ),
                    //     EditPasswordTextField(
                    //       controller: passwordController,
                    //       hintText: "Password",
                    //     ),
                    //     SizedBox(
                    //       height: 16,
                    //     ),
                    //     TextField(
                    //       controller: usernameController,
                    //       obscureText: false,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}