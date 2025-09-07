import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:flutter/material.dart' show Brightness, FloatingActionButtonThemeData, ThemeData, VisualDensity;

themeDarkData(font)=> ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
  primaryColor: AppColors.colorDarkPrimary,
  splashColor: AppColors.colorDarkThird,
  highlightColor: AppColors.colorDarkThird,
  cardColor: AppColors.colorDarkPrimary,
  dividerColor: AppColors.colorDarkThird,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.colorStarted, elevation: 2),
  fontFamily:font,
);
