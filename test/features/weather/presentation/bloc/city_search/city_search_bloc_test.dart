import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/features/weather/presentation/bloc/city_search/city_search_bloc.dart';

class MockSearchCities extends Mock implements SearchCities {}

void main() {
  late MockSearchCities searchCities;

  const miami = City(key: '347936', name: 'Miami', country: 'United States');
  const milwaukee =
      City(key: '351543', name: 'Milwaukee', country: 'United States');

  CitySearchBloc buildBloc({Duration debounceDuration = Duration.zero}) =>
      CitySearchBloc(
        searchCities: searchCities,
        debounceDuration: debounceDuration,
      );

  setUp(() {
    searchCities = MockSearchCities();
  });

  test('initial state is CitySearchInitial', () {
    expect(buildBloc().state, const CitySearchInitial());
  });

  group('CitySearchQueryChanged', () {
    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Loading, Success] with the cities found',
      setUp: () {
        when(() => searchCities('Mi')).thenAnswer(
          (_) async => const Success<List<City>>([miami, milwaukee]),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitySearchQueryChanged('Mi')),
      expect: () => const [
        CitySearchLoading(),
        CitySearchSuccess([miami, milwaukee]),
      ],
      verify: (_) => verify(() => searchCities('Mi')).called(1),
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Loading, Success] with an empty list when there are no matches',
      setUp: () {
        when(() => searchCities('Xyz'))
            .thenAnswer((_) async => const Success<List<City>>([]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitySearchQueryChanged('Xyz')),
      expect: () => const [CitySearchLoading(), CitySearchSuccess([])],
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Loading, Error] with the error when the search fails',
      setUp: () {
        when(() => searchCities('Mi')).thenAnswer(
          (_) async => const Failure<List<City>>(NoConnectionError()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitySearchQueryChanged('Mi')),
      expect: () => const [
        CitySearchLoading(),
        CitySearchError(NoConnectionError()),
      ],
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'searches again when the user types after an error',
      setUp: () {
        when(() => searchCities('Mi'))
            .thenAnswer((_) async => const Success<List<City>>([miami]));
      },
      build: buildBloc,
      seed: () => const CitySearchError(TimeoutError()),
      act: (bloc) => bloc.add(const CitySearchQueryChanged('Mi')),
      expect: () => const [CitySearchLoading(), CitySearchSuccess([miami])],
      verify: (_) => verify(() => searchCities('Mi')).called(1),
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Initial] without searching when the query is too short',
      build: buildBloc,
      seed: () => const CitySearchSuccess([miami]),
      act: (bloc) => bloc.add(const CitySearchQueryChanged('M')),
      expect: () => const [CitySearchInitial()],
      verify: (_) => verifyNever(() => searchCities(any())),
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'searches with the trimmed query',
      setUp: () {
        when(() => searchCities('Mi'))
            .thenAnswer((_) async => const Success<List<City>>([miami]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CitySearchQueryChanged('  Mi  ')),
      expect: () => const [CitySearchLoading(), CitySearchSuccess([miami])],
      verify: (_) => verify(() => searchCities('Mi')).called(1),
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'only searches the last query when the user types quickly (debounce)',
      setUp: () {
        when(() => searchCities(any()))
            .thenAnswer((_) async => const Success<List<City>>([miami]));
      },
      build: () =>
          buildBloc(debounceDuration: const Duration(milliseconds: 100)),
      act: (bloc) => bloc
        ..add(const CitySearchQueryChanged('Mi'))
        ..add(const CitySearchQueryChanged('Mia'))
        ..add(const CitySearchQueryChanged('Miam')),
      wait: const Duration(milliseconds: 300),
      expect: () => const [CitySearchLoading(), CitySearchSuccess([miami])],
      verify: (_) {
        verify(() => searchCities('Miam')).called(1);
        verifyNever(() => searchCities('Mi'));
        verifyNever(() => searchCities('Mia'));
      },
    );
  });

  group('CitySearchCleared', () {
    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Initial]',
      build: buildBloc,
      seed: () => const CitySearchSuccess([miami, milwaukee]),
      act: (bloc) => bloc.add(const CitySearchCleared()),
      expect: () => const [CitySearchInitial()],
    );

    blocTest<CitySearchBloc, CitySearchState>(
      'emits [Initial] after an error (the "x" button hides the error)',
      build: buildBloc,
      seed: () => const CitySearchError(NoConnectionError()),
      act: (bloc) => bloc.add(const CitySearchCleared()),
      expect: () => const [CitySearchInitial()],
    );
  });
}
