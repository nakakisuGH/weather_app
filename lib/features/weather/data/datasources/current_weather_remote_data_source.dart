import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/network/dio_error_mapper.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';

/// Fetches the current conditions of a city from AccuWeather.
class CurrentWeatherRemoteDataSource {
  const CurrentWeatherRemoteDataSource(this._dio);

  final Dio _dio;

  /// Returns the current weather of the city with the given [locationKey].
  /// Throws [NotFoundError] if the response has no conditions, or another
  /// [AppError] if the request fails.
  Future<CurrentWeatherModel> getCurrentWeather(String locationKey) async {
    try {
      final response = await _dio.get<dynamic>(
        '/currentconditions/v1/$locationKey',
      );

      final data = response.data;
      final first =
          data is List<dynamic> && data.isNotEmpty ? data.first : null;

      if (first is! Map<String, dynamic>) {
        throw const NotFoundError();
      }
      return CurrentWeatherModel.fromJson(first);
    } on AppError {
      rethrow;
    } on DioException catch (exception) {
      throw mapDioException(exception);
    } catch (error) {
      throw UnknownError(error.toString());
    }
  }
}
