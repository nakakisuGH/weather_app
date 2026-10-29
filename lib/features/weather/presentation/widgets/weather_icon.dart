import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/core/constants/app_images.dart';
import 'package:weather_app/core/theme/app_colors.dart';

/// Official AccuWeather icon for an icon number (1-44), from `assets/images/`.
/// Numbers: https://developer.accuweather.com/weather-icons
class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.iconNumber, {super.key, this.size = 32});

  final int iconNumber;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (AppImages.weatherIconNumbers.contains(iconNumber)) {
      return SvgPicture.asset(
        AppImages.weatherIcon(iconNumber),
        width: size,
        height: size,
      );
    }
    // 0 (missing in the response) or a number without an image.
    return Icon(
      Icons.help_outline,
      color: AppColors.textSecondary,
      size: size,
    );
  }
}
