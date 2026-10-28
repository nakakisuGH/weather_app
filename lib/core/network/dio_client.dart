import 'package:dio/dio.dart';

/// Creates the [Dio] instance shared by all remote datasources,
/// already configured for the AccuWeather API.
class DioClient {
  final Dio dio;
  
  static const String _baseUrl = 'https://dataservice.accuweather.com';
  static const String _apiKey = String.fromEnvironment('ACCUWEATHER_API_KEY');
  static const Duration _timeout = Duration(seconds: 10);  
  
  DioClient({String apiKey = _apiKey})
      : dio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: _timeout,
            receiveTimeout: _timeout,
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        );
}
