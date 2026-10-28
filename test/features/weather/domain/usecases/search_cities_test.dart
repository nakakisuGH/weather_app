import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/repositories/city_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late MockCityRepository repository;
  late SearchCities searchCities;

  const query = 'Mi';
  const cities = [
    City(key: '347936', name: 'Miami', country: 'United States'),
    City(key: '351543', name: 'Milwaukee', country: 'United States'),
    City(key: '348794', name: 'Minneapolis', country: 'United States'),
  ];

  setUp(() {
    repository = MockCityRepository();
    searchCities = SearchCities(cityRepository: repository);
  });

  group('SearchCities', () {
    test('returns the cities whose names start with the query', () async {
      // Arrange
      when(() => repository.searchCities(query))
          .thenAnswer((_) async => const Success(cities));

      // Act
      final result = await searchCities(query);

      // Assert
      expect(
        result,
        isA<Success<List<City>>>().having(
          (success) => success.data.map((city) => city.name).toList(),
          'city names',
          ['Miami', 'Milwaukee', 'Minneapolis'],
        ),
      );
      verify(() => repository.searchCities(query)).called(1);
    });

    test('trims the query before calling the repository', () async {
      when(() => repository.searchCities(query))
          .thenAnswer((_) async => const Success(cities));

      await searchCities('  Mi  ');

      verify(() => repository.searchCities('Mi')).called(1);
    });

    test(
      'returns an empty list without calling the repository '
      'when the query has fewer than ${SearchCities.minQueryLength} characters',
      () async {
        final result = await searchCities(' M ');

        expect(result, const Success<List<City>>([]));
        verifyNever(() => repository.searchCities(any()));
      },
    );

    test('returns an empty list when no city matches the query', () async {
      const unknownQuery = 'Xyzq';
      when(() => repository.searchCities(unknownQuery))
          .thenAnswer((_) async => const Success(<City>[]));

      final result = await searchCities(unknownQuery);

      expect(result, const Success<List<City>>([]));
    });

    test('returns Failure when the repository fails', () async {
      when(() => repository.searchCities(query))
          .thenAnswer((_) async => const Failure(NoConnectionError()));

      final result = await searchCities(query);

      expect(result, const Failure<List<City>>(NoConnectionError()));
    });
  });
}
