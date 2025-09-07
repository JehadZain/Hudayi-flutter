import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:flutter/material.dart' show BuildContext, Color, Image, Key, StatelessWidget, Widget, required;

class AppHeader extends StatelessWidget {
  final double height;
  const AppHeader({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppConstants.appHeader, height: height);
  }
}
