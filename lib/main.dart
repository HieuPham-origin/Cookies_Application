import 'package:cookie_app/pages/auth_page.dart';
import 'package:cookie_app/pages/information_page.dart';
import 'package:cookie_app/pages/settings_page.dart';
import 'package:cookie_app/pages/sign_in.dart';
import 'package:cookie_app/pages/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/signup': (context) => const SignUp(),
        '/signlamin': (context) => const SignIn(),
        '/profile': (context) => const SettingPage(),
        '/information': (context) => const InformationPage(),
      },
    );
  }
}
