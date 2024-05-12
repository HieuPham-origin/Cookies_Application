// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:cookie_app/pages/Home.dart';
import 'package:cookie_app/pages/home_page.dart';
import 'package:cookie_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerify = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerify) {
      sendVerifycationEmail();
      timer = Timer.periodic(
        Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerify) timer?.cancel();
  }

  Future sendVerifycationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerify) {
      FirebaseAuth.instance.currentUser!.reload();
      return Home();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Verify Email'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A verification email has been sent to your gmail.',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.0,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                icon: Icon(
                  Icons.email,
                  size: 32,
                ),
                label: Text(
                  'Resent email',
                  style: TextStyle(fontSize: 24.0),
                ),
                onPressed: canResendEmail ? sendVerifycationEmail : null,
              ),
              SizedBox(
                height: 8,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 24.0),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              )
            ],
          ),
        ),
      );
    }
  }
}
