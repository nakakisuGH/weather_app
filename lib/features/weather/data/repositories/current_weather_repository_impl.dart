import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/current_weather_remote_data_source.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/repositories/current_weather_repository.dart';

/// [CurrentWeatherRepository] backed by the AccuWeather current conditions endpoint.
class CurrentWeatherRepositoryImpl implements CurrentWeatherRepository {
  const CurrentWeatherRepositoryImpl(this._currentWeatherRemoteDataSource);

  final CurrentWeatherRemoteDataSource _currentWeatherRemoteDataSource;

  @override
  Future<Result<CurrentWeather>> getCurrentWeather(String locationKey) async {
    try {
      final currentWeatherModel =
          await _currentWeatherRemoteDataSource.getCurrentWeather(locationKey);
      return Success(currentWeatherModel.toEntity());
    } on AppError catch (error) {
      return Failure(error);
    }
  }
}
