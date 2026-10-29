import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_images.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

class WeatherAppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherAppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.logo, height: 32),
          const SizedBox(width: 4),
          const Text('WeatherForemost', style: AppTextStyles.appBarTitle),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
