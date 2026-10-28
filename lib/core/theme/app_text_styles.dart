import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';

/// Text styles from the Figma design. The font family comes from the theme (Work Sans).
abstract final class AppTextStyles {
  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const emptyTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const emptyMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
