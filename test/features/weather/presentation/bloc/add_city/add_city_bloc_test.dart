import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/presentation/bloc/add_city/add_city_bloc.dart';

class MockSaveCity extends Mock implements SaveCity {}

void main() {
  late MockSaveCity saveCity;

  const miami = City(key: '347936', name: 'Miami', country: 'United States');
  const milwaukee =
      City(key: '351543', name: 'Milwaukee', country: 'United States');
  const description = 'This is my favorite city.';

  setUpAll(() {
    registerFallbackValue(
      const SavedCity(
        city: City(key: '', name: '', country: ''),
        description: '',
      ),
    );
  });

  setUp(() {
    saveCity = MockSaveCity();
  });

  AddCityBloc buildBloc() => AddCityBloc(saveCity: saveCity);

  test('initial state has no city, no description and cannot save', () {
    final state = buildBloc().state;

    expect(state, const AddCityState());
    expect(state.selectedCity, isNull);
    expect(state.description, isEmpty);
    expect(state.status, AddCityStatus.editing);
    expect(state.canSave, isFalse);
  });

  group('canSave', () {
    test('is false with a city but no description', () {
      expect(const AddCityState(selectedCity: miami).canSave, isFalse);
    });

    test('is false with a description but no city', () {
      expect(const AddCityState(description: description).canSave, isFalse);
    });

    test('is false when the description only has spaces', () {
      expect(
        const AddCityState(selectedCity: miami, description: '   ').canSave,
        isFalse,
      );
    });

    test('is true with a city and a description', () {
      expect(
        const AddCityState(selectedCity: miami, description: description)
            .canSave,
        isTrue,
      );
    });

    test('is false while saving', () {
      expect(
        const AddCityState(
          selectedCity: miami,
          description: description,
          status: AddCityStatus.saving,
        ).canSave,
        isFalse,
      );
    });
  });

  group('AddCityCitySelected', () {
    blocTest<AddCityBloc, AddCityState>(
      'stores the selected city',
      build: buildBloc,
      act: (bloc) => bloc.add(const AddCityCitySelected(miami)),
      expect: () => const [AddCityState(selectedCity: miami)],
    );

    blocTest<AddCityBloc, AddCityState>(
      'clears a previous error and goes back to editing',
      build: buildBloc,
      seed: () => const AddCityState(
        selectedCity: miami,
        description: description,
        status: AddCityStatus.failure,
        error: CityAlreadySavedError(),
      ),
      act: (bloc) => bloc.add(const AddCityCitySelected(milwaukee)),
      expect: () => const [
        AddCityState(selectedCity: milwaukee, description: description),
      ],
    );
  });

  group('AddCityCityCleared', () {
    blocTest<AddCityBloc, AddCityState>(
      'removes the selected city and keeps the description',
      build: buildBloc,
      seed: () =>
          const AddCityState(selectedCity: miami, description: description),
      act: (bloc) => bloc.add(const AddCityCityCleared()),
      expect: () => const [AddCityState(description: description)],
    );
  });

  group('AddCityDescriptionChanged', () {
    blocTest<AddCityBloc, AddCityState>(
      'stores the description and keeps the selected city',
      build: buildBloc,
      seed: () => const AddCityState(selectedCity: miami),
      act: (bloc) => bloc.add(const AddCityDescriptionChanged(description)),
      expect: () => const [
        AddCityState(selectedCity: miami, description: description),
      ],
    );
  });

  group('AddCitySubmitted', () {
    blocTest<AddCityBloc, AddCityState>(
      'does nothing when the form cannot be saved',
      build: buildBloc,
      seed: () => const AddCityState(selectedCity: miami),
      act: (bloc) => bloc.add(const AddCitySubmitted()),
      expect: () => const <AddCityState>[],
      verify: (_) => verifyNever(() => saveCity(any())),
    );

    blocTest<AddCityBloc, AddCityState>(
      'emits [saving, saved] and saves the city with the trimmed description',
      setUp: () {
        when(() => saveCity(any()))
            .thenAnswer((_) async => const Success<void>(null));
      },
      build: buildBloc,
      seed: () => const AddCityState(
        selectedCity: miami,
        description: '  $description  ',
      ),
      act: (bloc) => bloc.add(const AddCitySubmitted()),
      expect: () => const [
        AddCityState(
          selectedCity: miami,
          description: '  $description  ',
          status: AddCityStatus.saving,
        ),
        AddCityState(
          selectedCity: miami,
          description: '  $description  ',
          status: AddCityStatus.saved,
        ),
      ],
      verify: (_) => verify(
        () => saveCity(const SavedCity(city: miami, description: description)),
      ).called(1),
    );

    blocTest<AddCityBloc, AddCityState>(
      'emits [saving, failure] when the city is already saved',
      setUp: () {
        when(() => saveCity(any())).thenAnswer(
          (_) async => const Failure<void>(CityAlreadySavedError()),
        );
      },
      build: buildBloc,
      seed: () =>
          const AddCityState(selectedCity: miami, description: description),
      act: (bloc) => bloc.add(const AddCitySubmitted()),
      expect: () => const [
        AddCityState(
          selectedCity: miami,
          description: description,
          status: AddCityStatus.saving,
        ),
        AddCityState(
          selectedCity: miami,
          description: description,
          status: AddCityStatus.failure,
          error: CityAlreadySavedError(),
        ),
      ],
    );
  });
}
