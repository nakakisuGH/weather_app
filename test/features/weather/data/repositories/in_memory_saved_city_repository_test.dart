import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/repositories/in_memory_saved_city_repository.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';

void main() {
  late InMemorySavedCityRepository repository;

  const savedMiami = SavedCity(
    city: City(key: '347936', name: 'Miami', country: 'United States'),
    description: 'This is my favorite city.',
  );
  const savedMilwaukee = SavedCity(
    city: City(key: '351543', name: 'Milwaukee', country: 'United States'),
    description: 'Cold winters.',
  );

  setUp(() {
    repository = InMemorySavedCityRepository();
  });

  group('InMemorySavedCityRepository', () {
    test('starts with no saved cities', () async {
      expect(await repository.getSavedCities(), isEmpty);
    });

    test('returns a city after saving it', () async {
      await repository.saveCity(savedMiami);

      expect(await repository.getSavedCities(), [savedMiami]);
    });

    test('keeps the cities in the order they were saved', () async {
      await repository.saveCity(savedMiami);
      await repository.saveCity(savedMilwaukee);

      expect(await repository.getSavedCities(), [savedMiami, savedMilwaukee]);
    });

    test('returns a list that cannot be modified', () async {
      await repository.saveCity(savedMiami);

      final savedCities = await repository.getSavedCities();

      expect(() => savedCities.add(savedMilwaukee), throwsUnsupportedError);
    });

    test('does not change a returned list when another city is saved',
        () async {
      await repository.saveCity(savedMiami);
      final savedCities = await repository.getSavedCities();

      await repository.saveCity(savedMilwaukee);

      expect(savedCities, [savedMiami]);
    });

    test('does not filter duplicates (SaveCity handles that rule)', () async {
      await repository.saveCity(savedMiami);
      await repository.saveCity(savedMiami);

      expect(await repository.getSavedCities(), hasLength(2));
    });
  });
}
