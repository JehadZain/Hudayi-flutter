import 'package:flutter/material.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/ui/helper/AppColors.dart';

class TabBarContainer extends StatelessWidget {
  final String title;
  final bool onlyText;
  const TabBarContainer({super.key, required this.title, required this.onlyText});

  @override
  Widget build(BuildContext context) {
    return onlyText == false
        ? Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(45),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Color(0x44111417),
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 19, right: 19, bottom: 2),
              child: Text(
                title,
                style:  TextStyle(fontSize: 14, fontFamily: getFontName(context)),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 19, right: 19, bottom: 2),
            child: Text(
              title,
              style:  TextStyle(fontSize: 14, fontFamily: getFontName(context)),
            ),
          );
  }
}
