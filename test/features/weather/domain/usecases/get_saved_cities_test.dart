import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/repositories/saved_city_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';

class MockSavedCityRepository extends Mock implements SavedCityRepository {}

void main() {
  late MockSavedCityRepository repository;
  late GetSavedCities getSavedCities;

  const savedCities = [
    SavedCity(
      city: City(key: '347936', name: 'Miami', country: 'United States'),
      description: 'This is my favorite city.',
    ),
    SavedCity(
      city: City(key: '351543', name: 'Milwaukee', country: 'United States'),
      description: 'Cold winters.',
    ),
  ];

  setUp(() {
    repository = MockSavedCityRepository();
    getSavedCities = GetSavedCities(repository);
  });

  group('GetSavedCities', () {
    test('returns the saved cities from the repository', () async {
      when(() => repository.getSavedCities())
          .thenAnswer((_) async => savedCities);

      final result = await getSavedCities();

      expect(result, savedCities);
      verify(() => repository.getSavedCities()).called(1);
    });

    test('returns an empty list when no cities are saved', () async {
      when(() => repository.getSavedCities())
          .thenAnswer((_) async => <SavedCity>[]);

      final result = await getSavedCities();

      expect(result, isEmpty);
    });
  });
}
