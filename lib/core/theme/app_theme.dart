import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        fontFamily: 'WorkSans',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBar,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.iconDisabled,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedIconTheme: IconThemeData(size: 25),
          unselectedIconTheme: IconThemeData(size: 25),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ); 
}
