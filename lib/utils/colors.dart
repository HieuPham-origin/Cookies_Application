import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const Color coffee =
      Color(0xFFb99b6b); // Make coffee static and corrected the alpha value
  static const Color cookie = Color(0xff7F5323);
  static const Color creamy = Color(0xFFFEF5E7);
  static const Color black_opacity = Color(0x80000000);
  static const Color background = Color(0xfff0f0f0);
  static const Color header_background = Color(0xfff7f7f7);
  static const Color grey_light = Color(0xff9A9A9A);
  static const Color red = Color(0xffAA5656);
  static const Color icon_grey = Color(0xff636363);
  static const Color title = Color(0xff020202);
  static const Color grey_heavy = Color(0xff474747);
  static const Color green = Color(0xff698269);
  static const Color blue = Color(0xFF9CC0DF);
  static const Color yellow = Color(0xFFFBC02D);
  static const Color orange = Color(0xffD38B42);
  static const Color purple = Color(0xff6C567B);

  //cookie list
  static const MaterialColor cookie_list = MaterialColor(
    0xff7F5323,
    <int, Color>{
      50: Color(0xff7F5323),
      100: Color(0xff7F5323),
      200: Color(0xff7F5323),
      300: Color(0xff7F5323),
      400: Color(0xff7F5323),
      500: Color(0xff7F5323),
      600: Color(0xff7F5323),
      700: Color(0xff7F5323),
      800: Color(0xff7F5323),
      900: Color(0xff7F5323),
    },
  );

  static const MaterialColor red_list = MaterialColor(
    0xFFAA5656,
    <int, Color>{
      50: Color(0xFFAA5656),
      100: Color(0xFFAA5656),
      200: Color(0xFFAA5656),
      300: Color(0xFFAA5656),
      400: Color(0xFFAA5656),
      500: Color(0xFFAA5656),
      600: Color(0xFFAA5656),
      700: Color(0xFFAA5656),
      800: Color(0xFFAA5656),
      900: Color(0xFFAA5656),
    },
  );
  static const MaterialColor green_list = MaterialColor(
    0xff698269,
    <int, Color>{
      50: Color(0xFF698269),
      100: Color(0xFF698269),
      200: Color(0xFF698269),
      300: Color(0xFF698269),
      400: Color(0xFF698269),
      500: Color(0xFF698269),
      600: Color(0xFF698269),
      700: Color(0xFF698269),
      800: Color(0xFF698269),
      900: Color(0xFF698269),
    },
  );
  static const MaterialColor blue_list = MaterialColor(
    0xFF9CC0DF,
    <int, Color>{
      50: Color(0xFF9CC0DF),
      100: Color(0xFF9CC0DF),
      200: Color(0xFF9CC0DF),
      300: Color(0xFF9CC0DF),
      400: Color(0xFF9CC0DF),
      500: Color(0xFF9CC0DF),
      600: Color(0xFF9CC0DF),
      700: Color(0xFF9CC0DF),
      800: Color(0xFF9CC0DF),
      900: Color(0xFF9CC0DF),
    },
  );

  //yellow_list
  static const MaterialColor yellow_list = MaterialColor(
    0xFFFBC02D,
    <int, Color>{
      50: Color(0xFFFBC02D),
      100: Color(0xFFFBC02D),
      200: Color(0xFFFBC02D),
      300: Color(0xFFFBC02D),
      400: Color(0xFFFBC02D),
      500: Color(0xFFFBC02D),
      600: Color(0xFFFBC02D),
      700: Color(0xFFFBC02D),
      800: Color(0xFFFBC02D),
      900: Color(0xFFFBC02D),
    },
  );

  static const MaterialColor grey_list = MaterialColor(
    0xff636363,
    <int, Color>{
      50: Color(0xff636363),
      100: Color(0xff636363),
      200: Color(0xff636363),
      300: Color(0xff636363),
      400: Color(0xff636363),
      500: Color(0xff636363),
      600: Color(0xff636363),
      700: Color(0xff636363),
      800: Color(0xff636363),
      900: Color(0xff636363),
    },
  );

  static const MaterialColor orange_list = MaterialColor(
    0xffD38B42,
    <int, Color>{
      50: Color(0xffD38B42),
      100: Color(0xffD38B42),
      200: Color(0xffD38B42),
      300: Color(0xffD38B42),
      400: Color(0xffD38B42),
      500: Color(0xffD38B42),
      600: Color(0xffD38B42),
      700: Color(0xffD38B42),
      800: Color(0xffD38B42),
      900: Color(0xffD38B42),
    },
  );

  //purple list
  static const MaterialColor purple_list = MaterialColor(
    0xff6C567B,
    <int, Color>{
      50: Color(0xff6C567B),
      100: Color(0xff6C567B),
      200: Color(0xff6C567B),
      300: Color(0xff6C567B),
      400: Color(0xff6C567B),
      500: Color(0xff6C567B),
      600: Color(0xff6C567B),
      700: Color(0xff6C567B),
      800: Color(0xff6C567B),
      900: Color(0xff6C567B),
    },
  );

  const AppColors();
}
