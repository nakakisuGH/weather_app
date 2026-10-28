import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/city_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/city_model.dart';
import 'package:weather_app/features/weather/data/repositories/city_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';

class MockCityRemoteDataSource extends Mock implements CityRemoteDataSource {}

void main() {
  late MockCityRemoteDataSource remoteDataSource;
  late CityRepositoryImpl repository;

  const query = 'Mi';

  setUp(() {
    remoteDataSource = MockCityRemoteDataSource();
    repository = CityRepositoryImpl(remoteDataSource);
  });

  group('CityRepositoryImpl.searchCities', () {
    test('returns Success with the cities converted to entities', () async {
      // Arrange
      when(() => remoteDataSource.searchCities(query)).thenAnswer(
        (_) async => const [
          CityModel(key: '347936', name: 'Miami', country: 'United States'),
          CityModel(key: '351543', name: 'Milwaukee', country: 'United States'),
        ],
      );

      // Act
      final result = await repository.searchCities(query);

      // Assert
      expect(
        result,
        const Success<List<City>>([
          City(key: '347936', name: 'Miami', country: 'United States'),
          City(key: '351543', name: 'Milwaukee', country: 'United States'),
        ]),
      );
    });

    test('passes the query to the remote datasource', () async {
      when(() => remoteDataSource.searchCities(query))
          .thenAnswer((_) async => <CityModel>[]);

      await repository.searchCities(query);

      verify(() => remoteDataSource.searchCities(query)).called(1);
    });

    test('returns Success with an empty list when there are no matches',
        () async {
      when(() => remoteDataSource.searchCities(query))
          .thenAnswer((_) async => <CityModel>[]);

      final result = await repository.searchCities(query);

      expect(result, const Success<List<City>>([]));
    });

    test('returns Failure with the AppError thrown by the datasource',
        () async {
      for (final error in const <AppError>[
        NoConnectionError(),
        TimeoutError(),
        UnauthorizedError(),
        ServerError(statusCode: 500),
      ]) {
        when(() => remoteDataSource.searchCities(query)).thenThrow(error);

        final result = await repository.searchCities(query);

        expect(result, Failure<List<City>>(error));
      }
    });
  });
}
