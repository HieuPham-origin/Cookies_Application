import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const Color coffee =
      Color(0xFFb99b6b); // Make coffee static and corrected the alpha value
  static const Color cookie = Color(0xff7F5323);
  static const Color creamy = Color.fromARGB(255, 254, 245, 231);
  static const Color black_opacity = Color(0x80000000);
  static const Color background = Color(0xFFF0F0F0);
  static const Color header_background = Color(0x00f7f7f7);
  static const Color grey_light = Color(0xff9A9A9A);
  static const Color red = Color(0xffAA5656);
  const AppColors();
}
