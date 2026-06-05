import 'package:flutter/material.dart';
import 'package:nubank_clone/constants/app_colors.dart';

const customTextTheme = TextTheme(
  titleMedium: TextStyle(
    fontSize: 17,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w300,
    letterSpacing: -1,
  ),
  titleSmall: TextStyle(
    color: AppColors.secondaryText,
    fontWeight: FontWeight.normal,
  ),
  displaySmall: TextStyle(
    fontSize: 35,
    color: AppColors.text,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
  ),
  headlineMedium: TextStyle(
    fontSize: 30,
    color: AppColors.text,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
  ),
  labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  bodySmall: TextStyle(height: 1.5),
  headlineSmall: TextStyle(fontWeight: FontWeight.bold),
  titleLarge: TextStyle(fontWeight: FontWeight.w400),
);

/// Mesma escala tipográfica, mas com as cores claras para o dark mode.
const customTextThemeDark = TextTheme(
  titleMedium: TextStyle(
    fontSize: 17,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w300,
    letterSpacing: -1,
  ),
  titleSmall: TextStyle(
    color: AppColors.secondaryText,
    fontWeight: FontWeight.normal,
  ),
  displaySmall: TextStyle(
    fontSize: 35,
    color: Color(0xFFFFFFFF),
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
  ),
  headlineMedium: TextStyle(
    fontSize: 30,
    color: Color(0xFFFFFFFF),
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
  ),
  labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  bodySmall: TextStyle(height: 1.5, color: Color(0xFFE5E5E5)),
  headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
  titleLarge: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),
  bodyMedium: TextStyle(color: Color(0xFFE5E5E5)),
  bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
);
