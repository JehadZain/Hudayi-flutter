import 'package:hudayi/ui/styles/appBorderRadius.dart';
import 'package:hudayi/ui/styles/appBoxShadow.dart';
import 'package:flutter/material.dart' show BoxDecoration, BuildContext, SizedBox, Theme;

class Helper {
  static bool? isDarkMode;
  static SizedBox get sizedBoxH5 => const SizedBox(height: 5);
  static SizedBox get sizedBoxH10 => const SizedBox(height: 10);
  static SizedBox get sizedBoxH15 => const SizedBox(height: 15);
  static SizedBox get sizedBoxH20 => const SizedBox(height: 20);
  static SizedBox get sizedBoxH25 => const SizedBox(height: 25);
  static SizedBox get sizedBoxH30 => const SizedBox(height: 30);
  static SizedBox get sizedBoxH50 => const SizedBox(height: 50);
  static SizedBox get sizedBoxH80 => const SizedBox(height: 80);
  static SizedBox get sizedBoxH100 => const SizedBox(height: 100);
  static SizedBox get sizedBoxW10 => const SizedBox(width: 10);
  static SizedBox get sizedBoxW5 => const SizedBox(width: 5);
  static SizedBox get sizedBoxW20 => const SizedBox(width: 20);
  static SizedBox get sizedBoxW80 => const SizedBox(width: 80);
  static BoxDecoration buildBoxDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).cardColor, borderRadius: AppBorderRadius.timeContainerRadius, boxShadow: [AppBoxShadow.containerBoxShadow]);

  static BoxDecoration buildOnboardingBoxDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).cardColor, borderRadius: AppBorderRadius.timeContainerRadius, boxShadow: [AppBoxShadow.containerBoxShadow]);
}
