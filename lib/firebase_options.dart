// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0ASDFto2x509NsjRrNppZGGiOQ7HEb2o',
    appId: '1:1004456404124:web:cf59b08ee2949fb78bb959',
    messagingSenderId: '1004456404124',
    projectId: 'cookieapp-46bb1',
    authDomain: 'cookieapp-46bb1.firebaseapp.com',
    storageBucket: 'cookieapp-46bb1.appspot.com',
    measurementId: 'G-8RV53W7FTF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8mmC5D6Z-9cRCyGlarWCQMl71N2QiUzQ',
    appId: '1:1004456404124:android:58034ab7fc642d4c8bb959',
    messagingSenderId: '1004456404124',
    projectId: 'cookieapp-46bb1',
    storageBucket: 'cookieapp-46bb1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3fALRuSMuq5t3QBqoY0-ELUA8_G-iqHE',
    appId: '1:1004456404124:ios:efdb813b62797a528bb959',
    messagingSenderId: '1004456404124',
    projectId: 'cookieapp-46bb1',
    storageBucket: 'cookieapp-46bb1.appspot.com',
    iosBundleId: 'com.example.cookieApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3fALRuSMuq5t3QBqoY0-ELUA8_G-iqHE',
    appId: '1:1004456404124:ios:93a4a0d5cb08eb498bb959',
    messagingSenderId: '1004456404124',
    projectId: 'cookieapp-46bb1',
    storageBucket: 'cookieapp-46bb1.appspot.com',
    iosBundleId: 'com.example.cookieApp.RunnerTests',
  );
}
