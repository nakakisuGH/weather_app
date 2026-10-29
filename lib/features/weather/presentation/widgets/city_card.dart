import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_weather_panel.dart';

/// Saved city in the Home: name and description on the left,
/// current weather on the right. Needs a CurrentWeatherBloc above it.
class CityCard extends StatelessWidget {
  const CityCard({super.key, required this.savedCity});

  final SavedCity savedCity;

  /// Text and weather panel share the width 5:2 (the panel is ~28%).
  static const int _textFlex = 5;
  static const int _panelFlex = 2;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Clips the panel to the rounded corners of the card.
      clipBehavior: Clip.antiAlias,
      // Makes the panel exactly as tall as the text (one or two lines).
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: _textFlex,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      savedCity.city.name,
                      style: AppTextStyles.cityName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      savedCity.description,
                      style: AppTextStyles.cityDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(flex: _panelFlex, child: CityWeatherPanel()),
          ],
        ),
      ),
    );
  }
}
