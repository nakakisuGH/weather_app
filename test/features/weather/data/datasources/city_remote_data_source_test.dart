import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/features/weather/data/datasources/city_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/city_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late CityRemoteDataSource dataSource;

  const path = '/locations/v1/cities/autocomplete';
  const query = 'Mi';

  void stubResponse(Object? data) {
    when(
      () => dio.get<dynamic>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: data,
      ),
    );
  }

  setUp(() {
    dio = MockDio();
    dataSource = CityRemoteDataSource(dio);
  });

  group('CityRemoteDataSource.searchCities', () {
    test('calls the autocomplete endpoint with the query', () async {
      stubResponse(fixture('cities_autocomplete.json'));

      await dataSource.searchCities(query);

      verify(() => dio.get<dynamic>(path, queryParameters: {'q': query}))
          .called(1);
    });

    test('returns the cities from the response', () async {
      stubResponse(fixture('cities_autocomplete.json'));

      final cities = await dataSource.searchCities(query);

      expect(cities, const [
        CityModel(key: '347936', name: 'Miami', country: 'United States'),
        CityModel(key: '351543', name: 'Milwaukee', country: 'United States'),
        CityModel(key: '348794', name: 'Minneapolis', country: 'United States'),
      ]);
    });

    test('skips cities without a key', () async {
      stubResponse([
        {'Key': '347936', 'LocalizedName': 'Miami'},
        {'LocalizedName': 'Nowhere'},
      ]);

      final cities = await dataSource.searchCities(query);

      expect(cities, const [
        CityModel(key: '347936', name: 'Miami', country: ''),
      ]);
    });

    test('returns an empty list when the body is not a list', () async {
      stubResponse({'Message': 'Unexpected'});

      expect(await dataSource.searchCities(query), isEmpty);
    });

    test('returns an empty list when the body is null', () async {
      stubResponse(null);

      expect(await dataSource.searchCities(query), isEmpty);
    });

    test('throws the mapped AppError when Dio fails', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            statusCode: 401,
          ),
        ),
      );

      expect(
        () => dataSource.searchCities(query),
        throwsA(const UnauthorizedError()),
      );
    });

    test('throws UnknownError when a field has an unexpected type', () async {
      stubResponse([
        {'Key': 347936, 'LocalizedName': 'Miami'},
      ]);

      expect(
        () => dataSource.searchCities(query),
        throwsA(isA<UnknownError>()),
      );
    });
  });
}
