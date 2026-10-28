import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/repositories/current_weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';

class MockCurrentWeatherRepository extends Mock
    implements CurrentWeatherRepository {}

void main() {
  late MockCurrentWeatherRepository repository;
  late GetCurrentWeather getCurrentWeather;

  const locationKey = '347936';
  final currentWeather = CurrentWeather(
    localObservationTime: DateTime(2026, 10, 26, 11),
    weatherIcon: 1,
    weatherText: 'Sunny',
  );

  setUp(() {
    repository = MockCurrentWeatherRepository();
    getCurrentWeather = GetCurrentWeather(repository);
  });

  group('GetCurrentWeather', () {
    test('returns Success with the current weather from the repository', () async {
      // Arrange
      when(() => repository.getCurrentWeather(locationKey))
          .thenAnswer((_) async => Success(currentWeather));

      // Act
      final result = await getCurrentWeather(locationKey);

      // Assert
      expect(result, Success(currentWeather));
      verify(() => repository.getCurrentWeather(locationKey)).called(1);
    });

    test('returns Failure when the repository fails', () async {
      when(() => repository.getCurrentWeather(locationKey))
          .thenAnswer((_) async => const Failure(NoConnectionError()));

      final result = await getCurrentWeather(locationKey);

      expect(result, const Failure<CurrentWeather>(NoConnectionError()));
    });
  });
}
