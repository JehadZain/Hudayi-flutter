import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:flutter/material.dart' show BuildContext, Image, Key, StatelessWidget, Widget;

class AppHeader extends StatelessWidget {
  final double height;
  const AppHeader({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppConstants.appHeader, height: height);
  }
}
