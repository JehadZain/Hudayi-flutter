import 'package:hudayi/ui/styles/appBorderRadius.dart';
import 'package:flutter/material.dart' show BoxDecoration, BoxShadow, BuildContext, Colors, Offset, Theme;

BoxDecoration buildBoxDecoration(BuildContext context) =>
    BoxDecoration(color: Theme.of(context).cardColor, borderRadius: AppBorderRadius.appBarRadiusLeft, boxShadow: [AppBoxShadow.containerBoxShadow]);

class AppBoxShadow {
  static BoxShadow get materialShadow => const BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10);
  static BoxShadow get containerBoxShadow => const BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 4, offset: Offset(0, 0));
}
