import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';

/// Root widget. Receives the use cases already built (in `main` or with mocks in tests)
/// and makes them available to the widgets below.
class WeatherApp extends StatelessWidget {
  const WeatherApp({
    super.key,
    required this.searchCities,
    required this.getCurrentWeather,
    required this.saveCity,
    required this.getSavedCities,
  });

  final SearchCities searchCities;
  final GetCurrentWeather getCurrentWeather;
  final SaveCity saveCity;
  final GetSavedCities getSavedCities;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: searchCities),
        RepositoryProvider.value(value: getCurrentWeather),
        RepositoryProvider.value(value: saveCity),
      ],
      child: BlocProvider(
        // Created right away (not when first read) so the list loads on startup.
        lazy: false,
        create: (_) => SavedCitiesBloc(getSavedCities: getSavedCities)
          ..add(const SavedCitiesRequested()),
        child: MaterialApp(
          title: 'WeatherForemost',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // Temporary until the Home screen exists.
          home: const Scaffold(body: Center(child: Text('WeatherForemost'))),
        ),
      ),
    );
  }
}
