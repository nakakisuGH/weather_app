import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/errors/app_error_message.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/core/utils/time_format.dart';
import 'package:weather_app/features/weather/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_icon.dart';

/// Light blue panel of a city card: weather icon and local time,
/// a loader while loading, or Retry when the request fails.
class CityWeatherPanel extends StatelessWidget {
  const CityWeatherPanel({super.key});

  static const double _loaderSize = 24;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.weatherPanel,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
          builder: (context, state) => switch (state) {
            CurrentWeatherInitial() || CurrentWeatherLoading() => const Center(
                child: SizedBox.square(
                  dimension: _loaderSize,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            CurrentWeatherSuccess(:final weather) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WeatherIcon(weather.weatherIcon),
                  const SizedBox(height: 4),
                  Text(
                    formatTime12h(weather.localObservationTime),
                    style: AppTextStyles.weatherTime,
                    maxLines: 1,
                  ),
                ],
              ),
            CurrentWeatherError(:final error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    color: AppColors.primary,
                    tooltip: error.userMessage,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context
                        .read<CurrentWeatherBloc>()
                        .add(const CurrentWeatherRequested()),
                  ),
                  const Text(
                    'Retry',
                    style: AppTextStyles.weatherTime,
                    maxLines: 1,
                  ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
