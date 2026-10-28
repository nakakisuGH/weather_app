import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/network/dio_error_mapper.dart';
import 'package:weather_app/features/weather/data/models/city_model.dart';

/// Fetches city suggestions from the AccuWeather autocomplete endpoint.
class CityRemoteDataSource {
  const CityRemoteDataSource(this._dio);

  final Dio _dio;

  /// Returns the cities whose names start with [query].
  /// Throws an [AppError] if the request fails.
  Future<List<CityModel>> searchCities(String query) async {
    try {
      final response = await _dio.get<dynamic>(
        '/locations/v1/cities/autocomplete',
        queryParameters: {'q': query},
      );

      final data = response.data;
      final items = data is List<dynamic> ? data : const <dynamic>[];

      return items
          .whereType<Map<String, dynamic>>()
          .map(CityModel.fromJson)
          .where((city) => city.key.isNotEmpty)
          .toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    } catch (error) {
      throw UnknownError(error.toString());
    }
  }
}
