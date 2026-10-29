import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_card.dart';

/// List of saved cities in the Home. Each card gets its own
/// CurrentWeatherBloc, so it loads (and fails or retries) independently.
class SavedCitiesList extends StatelessWidget {
  const SavedCitiesList({super.key, required this.savedCities});

  final List<SavedCity> savedCities;

  /// Leaves room under the last card so the + button does not cover it.
  static const double _bottomPadding = 104;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, _bottomPadding),
      itemCount: savedCities.length,
      itemBuilder: (context, index) {
        final savedCity = savedCities[index];
        return Padding(
          // When the list reloads after adding a city, cards that were already
          // there keep their bloc (and their weather): only the new one loads.
          key: ValueKey(savedCity.city.key),
          padding: const EdgeInsets.only(bottom: 12),
          child: BlocProvider(
            create: (context) => CurrentWeatherBloc(
              getCurrentWeather: context.read<GetCurrentWeather>(),
              locationKey: savedCity.city.key,
            )..add(const CurrentWeatherRequested()),
            child: CityCard(savedCity: savedCity),
          ),
        );
      },
    );
  }
}
