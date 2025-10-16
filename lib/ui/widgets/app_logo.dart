import 'package:hudayi/ui/helper/App_Constants.dart';
import 'package:flutter/material.dart'
    show BuildContext, Image, StatelessWidget, Widget;

class AppLogo extends StatelessWidget {
  final double height;
  const AppLogo({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppConstants.appLogo, height: height);
  }
}
