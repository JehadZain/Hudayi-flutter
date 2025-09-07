import 'package:flutter/material.dart';

class AppBorderRadius {
  static BorderRadiusDirectional get appBarRadiusLeft => const BorderRadiusDirectional.only(topEnd: Radius.circular(19), bottomEnd: Radius.circular(19));
  static BorderRadiusDirectional get appBarRadiusRight => const BorderRadiusDirectional.only(topStart: Radius.circular(19), bottomStart: Radius.circular(19));
  static BorderRadius get bottomBarRadius => const BorderRadius.vertical(top: Radius.circular(50));
  static BorderRadius get onboardingBarRadius => const BorderRadius.all(Radius.circular(50));
  static BorderRadius get timeContainerRadius => const BorderRadius.all(Radius.circular(14));
  static BorderRadius get textEditingBorderRadius => const BorderRadius.all(Radius.circular(10));
  static RoundedRectangleBorder get fabRadius =>
      const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)));
  static RoundedRectangleBorder get alertDialogRadius => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
  static Radius get buttonRadius => const Radius.circular(50);
}
