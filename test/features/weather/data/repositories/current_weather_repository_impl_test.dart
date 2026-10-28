import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/current_weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/current_weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

class MockCurrentWeatherRemoteDataSource extends Mock
    implements CurrentWeatherRemoteDataSource {}

void main() {
  late MockCurrentWeatherRemoteDataSource remoteDataSource;
  late CurrentWeatherRepositoryImpl repository;

  const locationKey = '347936';

  setUp(() {
    remoteDataSource = MockCurrentWeatherRemoteDataSource();
    repository = CurrentWeatherRepositoryImpl(remoteDataSource);
  });

  group('CurrentWeatherRepositoryImpl.getCurrentWeather', () {
    test('returns Success with the current weather converted to an entity',
        () async {
      // Arrange
      when(() => remoteDataSource.getCurrentWeather(locationKey)).thenAnswer(
        (_) async => CurrentWeatherModel(
          localObservationTime: DateTime(2026, 10, 26, 11),
          weatherIcon: 1,
          weatherText: 'Sunny',
        ),
      );

      // Act
      final result = await repository.getCurrentWeather(locationKey);

      // Assert
      expect(
        result,
        Success(
          CurrentWeather(
            localObservationTime: DateTime(2026, 10, 26, 11),
            weatherIcon: 1,
            weatherText: 'Sunny',
          ),
        ),
      );
    });

    test('keeps a null observation time when converting', () async {
      when(() => remoteDataSource.getCurrentWeather(locationKey)).thenAnswer(
        (_) async => const CurrentWeatherModel(
          localObservationTime: null,
          weatherIcon: 0,
          weatherText: '',
        ),
      );

      final result = await repository.getCurrentWeather(locationKey);

      expect(
        result,
        const Success(
          CurrentWeather(
            localObservationTime: null,
            weatherIcon: 0,
            weatherText: '',
          ),
        ),
      );
    });

    test('passes the location key to the remote datasource', () async {
      when(() => remoteDataSource.getCurrentWeather(locationKey)).thenAnswer(
        (_) async => const CurrentWeatherModel(
          localObservationTime: null,
          weatherIcon: 1,
          weatherText: 'Sunny',
        ),
      );

      await repository.getCurrentWeather(locationKey);

      verify(() => remoteDataSource.getCurrentWeather(locationKey)).called(1);
    });

    test('returns Failure with the AppError thrown by the datasource',
        () async {
      for (final error in const <AppError>[
        NotFoundError(),
        NoConnectionError(),
        TimeoutError(),
        UnauthorizedError(),
        ServerError(statusCode: 500),
      ]) {
        when(() => remoteDataSource.getCurrentWeather(locationKey))
            .thenThrow(error);

        final result = await repository.getCurrentWeather(locationKey);

        expect(result, Failure<CurrentWeather>(error));
      }
    });
  });
}
