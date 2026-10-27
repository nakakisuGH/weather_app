import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

abstract interface class WeatherRepository {
  /// Fetches the current weather for the city with the given [locationKey].
  Future<Result<CurrentWeather>> getCurrentWeather(String locationKey);
}
