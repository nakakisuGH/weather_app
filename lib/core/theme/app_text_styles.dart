import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';

/// Text styles from the Figma design. The font family comes from the theme (Work Sans).
abstract final class AppTextStyles {
  static const appBarTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const emptyTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static const emptyMessage = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.1,
  );
}
