import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:flutter/material.dart' show BuildContext, Color, Image, Key, StatelessWidget, Widget, required;

class AppLogo extends StatelessWidget {
  final double height;
  const AppLogo({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppConstants.appLogo, height: height);
  }
}
