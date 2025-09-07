import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/styles/appBorderRadius.dart';
import 'package:hudayi/ui/widgets/appHeader.dart';

class CustomAppBar extends StatelessWidget {
  final IconData firstIcon;
  final Function() firstIconOnTap;
  final IconData secondIcon;
  final Function() secondIconOnTap;
  const CustomAppBar({super.key, required this.firstIcon, required this.firstIconOnTap, required this.secondIcon, required this.secondIconOnTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppBorderRadius.appBarRadiusLeft),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: GestureDetector(
              onTap: firstIconOnTap,
              child: Icon(
                firstIcon,
                color: AppColors.colorLightCardColors,
              ),
            ),
          ),
        ),
        const AppHeader(height: 70),
        Container(
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppBorderRadius.appBarRadiusRight),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: GestureDetector(
              onTap: secondIconOnTap,
              child: Icon(
                secondIcon,
                color: AppColors.colorLightCardColors,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
