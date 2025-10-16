import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:flutter/material.dart' show Brightness, Colors, FloatingActionButtonThemeData, ThemeData, VisualDensity;

 themeLightData(font)=> ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  primaryColorDark: AppColors.colorDarkPrimary,
  splashColor: Colors.transparent,
  highlightColor: AppColors.primary,
  cardColor: AppColors.colorLightCardColors,
  dividerColor: AppColors.colorLightPrimary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.colorStarted, elevation: 2),
  fontFamily: font,
);
