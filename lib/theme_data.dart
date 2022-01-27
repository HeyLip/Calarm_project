import 'package:flutter/material.dart';

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> white = [Color(0xFFFFFFFF), Color(0xFFFFFFFF)];
  static List<Color> grey = [Color(0xFFE0E0E0), Color(0xFFE0E0E0)];
  //static List<Color> forest = [Color(0xFFACE163), Color(0xFFD2EFAF)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.white),
    GradientColors(GradientColors.grey),
  ];
}

class FontColors {
  static List<Color> colors = [
    Color(0xFFFFB800),
    Color(0xFF909090),
    Color(0xFF3A3A3A)
  ];
}

class NewAlarmColors {
  // 요일 버튼의 색상. 일~토요일 순 .
  static List<Color> dayColor = [
    Colors.red,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.blue
  ];

  // 요일 버튼의 밑줄 색 (선택시 표시되는 밑줄)
  static Color underLineColor1 = Colors.grey.shade200;
  static Color underLineColor2 = Colors.blue;

  // 옵션박스 색
  static Color optionBoxColor = Colors.grey.shade200;

  // divider 색
  static Color dividerColor = Colors.grey;
}

class AlarmWindowColors {
  static Color backgroundColor1 = Color(0xffFFD98F);
  static Color backgroundColor2 = Color(0xffFFA256);
  static Color backgroundColor3 = Color(0xffFF8540);
  static Color sliderColor = Color(0xffFFB800);

  static Color timeColor = Colors.white;

  static Color textColor1 = Color(0xff202020);
  static Color textColor2 = Colors.white;

  static Color shadowColor = Color(0xff4E4E4E);
}
