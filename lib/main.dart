import 'package:flutter/material.dart';
import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/features/weather/data/datasources/city_remote_data_source.dart';
import 'package:weather_app/features/weather/data/datasources/current_weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/repositories/city_repository_impl.dart';
import 'package:weather_app/features/weather/data/repositories/current_weather_repository_impl.dart';
import 'package:weather_app/features/weather/data/repositories/in_memory_saved_city_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/weather_app.dart';

/// Builds every dependency once and starts the app.
/// This is the only place that knows the `data` implementations.
void main() {
  final dio = DioClient().dio;
  // A single instance: every screen must see the same saved cities.
  final savedCityRepository = InMemorySavedCityRepository();

  runApp(
    WeatherApp(
      searchCities: SearchCities(
        cityRepository: CityRepositoryImpl(CityRemoteDataSource(dio)),
      ),
      getCurrentWeather: GetCurrentWeather(
        CurrentWeatherRepositoryImpl(CurrentWeatherRemoteDataSource(dio)),
      ),
      saveCity: SaveCity(savedCityRepository),
      getSavedCities: GetSavedCities(savedCityRepository),
    ),
  );
}
