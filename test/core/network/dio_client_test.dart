import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/network/dio_client.dart';

void main() {
  late DioClient dioClient;

  setUp(() {
    dioClient = DioClient(apiKey: 'test-key');
  });

  group('DioClient', () {
    test('uses the AccuWeather base URL', () {
      expect(
        dioClient.dio.options.baseUrl,
        'https://dataservice.accuweather.com',
      );
    });

    test('sets connect and receive timeouts of 10 seconds', () {
      expect(dioClient.dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dioClient.dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('sends the API key as a Bearer token', () {
      expect(
        dioClient.dio.options.headers['Authorization'],
        'Bearer test-key',
      );
    });
  });
}
