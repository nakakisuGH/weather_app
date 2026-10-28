import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';

class MockGetSavedCities extends Mock implements GetSavedCities {}

void main() {
  late MockGetSavedCities getSavedCities;

  const savedMiami = SavedCity(
    city: City(key: '347936', name: 'Miami', country: 'United States'),
    description: 'This is my favorite city.',
  );
  const savedMilwaukee = SavedCity(
    city: City(key: '351543', name: 'Milwaukee', country: 'United States'),
    description: 'Cold winters.',
  );

  setUp(() {
    getSavedCities = MockGetSavedCities();
  });

  SavedCitiesBloc buildBloc() =>
      SavedCitiesBloc(getSavedCities: getSavedCities);

  test('initial state is SavedCitiesInitial', () {
    expect(buildBloc().state, const SavedCitiesInitial());
  });

  group('SavedCitiesRequested', () {
    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'emits [Loading, Success] with the saved cities',
      setUp: () {
        when(() => getSavedCities()).thenAnswer((_) async => [savedMiami]);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const SavedCitiesRequested()),
      expect: () => const [
        SavedCitiesLoading(),
        SavedCitiesSuccess([savedMiami]),
      ],
      verify: (_) => verify(() => getSavedCities()).called(1),
    );

    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'emits [Loading, Success] with an empty list when nothing is saved',
      setUp: () {
        when(() => getSavedCities()).thenAnswer((_) async => <SavedCity>[]);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const SavedCitiesRequested()),
      expect: () => const [SavedCitiesLoading(), SavedCitiesSuccess([])],
    );

    blocTest<SavedCitiesBloc, SavedCitiesState>(
      'reloads without emitting Loading when a list is already shown',
      setUp: () {
        when(() => getSavedCities())
            .thenAnswer((_) async => [savedMiami, savedMilwaukee]);
      },
      build: buildBloc,
      seed: () => const SavedCitiesSuccess([savedMiami]),
      act: (bloc) => bloc.add(const SavedCitiesRequested()),
      expect: () => const [
        SavedCitiesSuccess([savedMiami, savedMilwaukee]),
      ],
    );
  });
}
