import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/repositories/saved_city_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';

class MockSavedCityRepository extends Mock implements SavedCityRepository {}

void main() {
  late MockSavedCityRepository repository;
  late SaveCity saveCity;

  const miami = City(key: '347936', name: 'Miami', country: 'United States');
  const milwaukee =
      City(key: '351543', name: 'Milwaukee', country: 'United States');
  const savedMiami =
      SavedCity(city: miami, description: 'This is my favorite city.');

  setUpAll(() {
    registerFallbackValue(
      const SavedCity(
        city: City(key: '', name: '', country: ''),
        description: '',
      ),
    );
  });

  setUp(() {
    repository = MockSavedCityRepository();
    saveCity = SaveCity(repository);
    when(() => repository.saveCity(any())).thenAnswer((_) async {});
  });

  group('SaveCity', () {
    test('saves the city and returns Success when it is not saved yet',
        () async {
      // Arrange
      when(() => repository.getSavedCities()).thenAnswer(
        (_) async => const [
          SavedCity(city: milwaukee, description: 'Cold winters.'),
        ],
      );

      // Act
      final result = await saveCity(savedMiami);

      // Assert
      expect(result, const Success<void>(null));
      verify(() => repository.saveCity(savedMiami)).called(1);
    });

    test('saves the city when there are no saved cities yet', () async {
      when(() => repository.getSavedCities())
          .thenAnswer((_) async => <SavedCity>[]);

      final result = await saveCity(savedMiami);

      expect(result, const Success<void>(null));
      verify(() => repository.saveCity(savedMiami)).called(1);
    });

    test(
      'returns CityAlreadySavedError and does not save '
      'when a city with the same key is already saved',
      () async {
        when(() => repository.getSavedCities())
            .thenAnswer((_) async => const [savedMiami]);

        final result = await saveCity(
          const SavedCity(city: miami, description: 'Another description.'),
        );

        expect(result, const Failure<void>(CityAlreadySavedError()));
        verifyNever(() => repository.saveCity(any()));
      },
    );
  });
}
