import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/features/weather/data/datasources/current_weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late CurrentWeatherRemoteDataSource dataSource;

  const locationKey = '347936';
  const path = '/currentconditions/v1/$locationKey';

  void stubResponse(Object? data) {
    when(() => dio.get<dynamic>(any())).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: data,
      ),
    );
  }

  setUp(() {
    dio = MockDio();
    dataSource = CurrentWeatherRemoteDataSource(dio);
  });

  group('CurrentWeatherRemoteDataSource.getCurrentWeather', () {
    test('calls the current conditions endpoint with the location key',
        () async {
      stubResponse(fixture('current_conditions.json'));

      await dataSource.getCurrentWeather(locationKey);

      verify(() => dio.get<dynamic>(path)).called(1);
    });

    test('returns the current weather from the response', () async {
      stubResponse(fixture('current_conditions.json'));

      final currentWeather = await dataSource.getCurrentWeather(locationKey);

      expect(
        currentWeather,
        CurrentWeatherModel(
          localObservationTime: DateTime(2026, 10, 26, 11),
          weatherIcon: 1,
          weatherText: 'Sunny',
        ),
      );
    });

    test('throws NotFoundError when the list is empty', () async {
      stubResponse(<dynamic>[]);

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(const NotFoundError()),
      );
    });

    test('throws NotFoundError when the body is not a list', () async {
      stubResponse({'Message': 'Unexpected'});

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(const NotFoundError()),
      );
    });

    test('throws NotFoundError when the body is null', () async {
      stubResponse(null);

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(const NotFoundError()),
      );
    });

    test('throws NotFoundError when the first item is not an object', () async {
      stubResponse(['unexpected']);

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(const NotFoundError()),
      );
    });

    test('throws the mapped AppError when Dio fails', () async {
      when(() => dio.get<dynamic>(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(const NoConnectionError()),
      );
    });

    test('throws UnknownError when a field has an unexpected type', () async {
      stubResponse([
        {'WeatherIcon': '1', 'WeatherText': 'Sunny'},
      ]);

      expect(
        () => dataSource.getCurrentWeather(locationKey),
        throwsA(isA<UnknownError>()),
      );
    });
  });
}
