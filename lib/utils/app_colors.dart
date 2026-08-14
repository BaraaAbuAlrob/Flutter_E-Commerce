import 'package:flutter/material.dart';

class AppColors {
  static const grey = Colors.grey;
  static final greyWithShade300 = Colors.grey.shade300;
  static const white = Colors.white;
  static const red = Colors.red;
  static const Color green = Colors.green;
  static const Color yellow = Colors.yellow;
  static const Color black = Colors.black;
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
