import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/repositories/current_weather_repository.dart';

class GetCurrentWeather {
  const GetCurrentWeather(this._currentWeatherRepository);

  final CurrentWeatherRepository _currentWeatherRepository;

  Future<Result<CurrentWeather>> call(String locationKey) =>
      _currentWeatherRepository.getCurrentWeather(locationKey);
}
