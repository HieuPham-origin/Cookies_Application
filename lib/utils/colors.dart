import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const Color coffee =
      Color(0xFFb99b6b); // Make coffee static and corrected the alpha value
  static const Color cookie = Color(0xff7F5323);
  static const Color creamy = Color.fromARGB(255, 254, 245, 231);
  static const Color black_opacity = Color(0x80000000);
  static const Color background = Color(0xfff0f0f0);
  static const Color header_background = Color(0xfff7f7f7);
  static const Color grey_light = Color(0xff9A9A9A);
  static const Color red = Color(0xffAA5656);
  static const Color icon_grey = Color(0xff636363);
  static const Color title = Color(0xff020202);
  static const Color grey_heavy = Color(0xff474747);
  static const Color green = Color(0xff698269);
  static const Color blue = Color.fromARGB(255, 156, 192, 223);
  const AppColors();
}
