import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppRadius {
  AppRadius._();

  static const r6 = 6.0;
  static const r8 = 8.0;
  static const r10 = 10.0;
  static const r12 = 12.0;
  static const r14 = 14.0;
  static const r16 = 16.0;
  static const r24 = 24.0;
  static const r999 = 999.0;
}

class AppFonts {
  AppFonts._();

  static const font1 = 'PlusJakartaSans';
  static const font2 = 'Montserrat';
  static const font3 = 'Poppins';
}

class AppStyle {
  AppStyle._();

  /// --container-border
  static const containerBorder =
      BorderSide(color: AppColors.azureMartinique, width: 1);

  /// --drop-shadow
  static const dropShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 5),
      blurRadius: 14,
    ),
  ];
}