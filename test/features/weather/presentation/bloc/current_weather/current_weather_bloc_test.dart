import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/current_weather/current_weather_bloc.dart';

class MockGetCurrentWeather extends Mock implements GetCurrentWeather {}

void main() {
  late MockGetCurrentWeather getCurrentWeather;

  const locationKey = '347936';
  final weather = CurrentWeather(
    localObservationTime: DateTime(2026, 10, 26, 11),
    weatherIcon: 1,
    weatherText: 'Sunny',
  );

  setUp(() {
    getCurrentWeather = MockGetCurrentWeather();
  });

  CurrentWeatherBloc buildBloc() => CurrentWeatherBloc(
        getCurrentWeather: getCurrentWeather,
        locationKey: locationKey,
      );

  test('initial state is CurrentWeatherInitial', () {
    expect(buildBloc().state, const CurrentWeatherInitial());
  });

  group('CurrentWeatherRequested', () {
    blocTest<CurrentWeatherBloc, CurrentWeatherState>(
      'emits [Loading, Success] with the weather of the city key',
      setUp: () {
        when(() => getCurrentWeather(locationKey))
            .thenAnswer((_) async => Success(weather));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CurrentWeatherRequested()),
      expect: () => [const CurrentWeatherLoading(), CurrentWeatherSuccess(weather)],
      verify: (_) => verify(() => getCurrentWeather(locationKey)).called(1),
    );

    blocTest<CurrentWeatherBloc, CurrentWeatherState>(
      'emits [Loading, Error] when the request fails',
      setUp: () {
        when(() => getCurrentWeather(locationKey)).thenAnswer(
          (_) async => const Failure<CurrentWeather>(NoConnectionError()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CurrentWeatherRequested()),
      expect: () => const [
        CurrentWeatherLoading(),
        CurrentWeatherError(NoConnectionError()),
      ],
    );

    blocTest<CurrentWeatherBloc, CurrentWeatherState>(
      'loads the weather again when retrying after an error',
      setUp: () {
        when(() => getCurrentWeather(locationKey))
            .thenAnswer((_) async => Success(weather));
      },
      build: buildBloc,
      seed: () => const CurrentWeatherError(TimeoutError()),
      act: (bloc) => bloc.add(const CurrentWeatherRequested()),
      expect: () => [const CurrentWeatherLoading(), CurrentWeatherSuccess(weather)],
    );

    blocTest<CurrentWeatherBloc, CurrentWeatherState>(
      'ignores a second request while the first one is in progress',
      setUp: () {
        // A slow response, like a real API call.
        when(() => getCurrentWeather(locationKey)).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => Success(weather),
          ),
        );
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const CurrentWeatherRequested());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(const CurrentWeatherRequested());
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [const CurrentWeatherLoading(), CurrentWeatherSuccess(weather)],
      verify: (_) => verify(() => getCurrentWeather(locationKey)).called(1),
    );
  });
}
