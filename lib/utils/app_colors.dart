import 'package:flutter/material.dart';

class AppColors {
  static const grey = Colors.grey;
  static final grey500 = Colors.grey.shade500;
  static final grey300 = Colors.grey.shade300;
  static final grey100 = Colors.grey.shade100;
  static final grey200 = Colors.grey.shade200;
  static const white = Colors.white;
  static const red = Colors.red;
  static const Color green = Colors.green;
  static const Color yellow = Colors.yellow;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black12 = Colors.black12;
  static const Color black45 = Colors.black45;
  static const Color blue = Colors.blue;
  static const primary = Colors.lightBlue;

  static Color? getColorByName(String name) {
    switch (name) {
      case 'black':
        return black;
      case 'white':
        return white;
      case 'red':
        return red;
      case 'blue':
        return blue;
      case 'green':
        return green;
      case 'yellow':
        return yellow;
      default:
        return null;
    }
  }
}
