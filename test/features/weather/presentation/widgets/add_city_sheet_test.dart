import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/presentation/bloc/add_city/add_city_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/city_search/city_search_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/add_city_sheet.dart';

class MockCitySearchBloc extends MockBloc<CitySearchEvent, CitySearchState>
    implements CitySearchBloc {}

class MockAddCityBloc extends MockBloc<AddCityEvent, AddCityState>
    implements AddCityBloc {}

class MockSavedCitiesBloc extends MockBloc<SavedCitiesEvent, SavedCitiesState>
    implements SavedCitiesBloc {}

void main() {
  late MockCitySearchBloc citySearchBloc;
  late MockAddCityBloc addCityBloc;
  late MockSavedCitiesBloc savedCitiesBloc;

  const miami = City(key: '347936', name: 'Miami', country: 'United States');
  const milwaukee =
      City(key: '351543', name: 'Milwaukee', country: 'United States');

  setUp(() {
    citySearchBloc = MockCitySearchBloc();
    addCityBloc = MockAddCityBloc();
    savedCitiesBloc = MockSavedCitiesBloc();
    when(() => citySearchBloc.state).thenReturn(const CitySearchInitial());
    when(() => addCityBloc.state).thenReturn(const AddCityState());
  });

  /// The blocs go above MaterialApp (as in the real app) so the sheet's
  /// route can read them.
  Widget withBlocs(Widget app) => MultiBlocProvider(
        providers: [
          BlocProvider<CitySearchBloc>.value(value: citySearchBloc),
          BlocProvider<AddCityBloc>.value(value: addCityBloc),
          BlocProvider<SavedCitiesBloc>.value(value: savedCitiesBloc),
        ],
        child: app,
      );

  Future<void> pumpSheet(WidgetTester tester) => tester.pumpWidget(
        withBlocs(
          MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(body: AddCitySheet()),
          ),
        ),
      );

  Finder cityField() => find.widgetWithText(TextField, 'Add City');

  String cityText(WidgetTester tester) =>
      tester.widget<TextField>(cityField()).controller?.text ?? '';

  FilledButton saveButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('shows the empty form with "Save City" disabled', (tester) async {
    await pumpSheet(tester);

    expect(cityField(), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Add a description'), findsOneWidget);
    expect(find.text('Save City'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNull);
  });

  testWidgets('typing a city starts a search', (tester) async {
    await pumpSheet(tester);

    await tester.enterText(cityField(), 'Mi');

    verify(() => citySearchBloc.add(const CitySearchQueryChanged('Mi')))
        .called(1);
    verifyNever(() => addCityBloc.add(const AddCityCityCleared()));
  });

  testWidgets('editing the text clears the selected city', (tester) async {
    when(() => addCityBloc.state)
        .thenReturn(const AddCityState(selectedCity: miami));
    await pumpSheet(tester);

    await tester.enterText(cityField(), 'Mia');

    verify(() => addCityBloc.add(const AddCityCityCleared())).called(1);
  });

  testWidgets('typing a description sends it to the bloc', (tester) async {
    await pumpSheet(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Description'),
      'My favorite city',
    );

    verify(
      () => addCityBloc.add(const AddCityDescriptionChanged('My favorite city')),
    ).called(1);
  });

  testWidgets('shows a loader while searching', (tester) async {
    when(() => citySearchBloc.state).thenReturn(const CitySearchLoading());
    await pumpSheet(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Description'), findsNothing);
  });

  testWidgets('shows a message when no cities are found', (tester) async {
    when(() => citySearchBloc.state).thenReturn(const CitySearchSuccess([]));
    await pumpSheet(tester);

    expect(find.text('No cities found'), findsOneWidget);
  });

  testWidgets('shows the error and how to retry when the search fails',
      (tester) async {
    when(() => citySearchBloc.state)
        .thenReturn(const CitySearchError(NoConnectionError()));
    await pumpSheet(tester);

    expect(
      find.text('No internet connection.\nEdit the text to try again.'),
      findsOneWidget,
    );
  });

  testWidgets('selecting a suggestion completes the text and selects the city',
      (tester) async {
    when(() => citySearchBloc.state)
        .thenReturn(const CitySearchSuccess([miami, milwaukee]));
    await pumpSheet(tester);
    expect(find.text('Milwaukee'), findsOneWidget);
    expect(find.text('Description'), findsNothing);

    await tester.enterText(cityField(), 'Mi');
    await tester.tap(find.text('Miami'));
    await tester.pump();

    expect(cityText(tester), 'Miami');
    verify(() => addCityBloc.add(const AddCityCitySelected(miami))).called(1);
    verify(() => citySearchBloc.add(const CitySearchCleared())).called(1);
  });

  testWidgets('the clear button empties the field and the selection',
      (tester) async {
    await pumpSheet(tester);
    expect(find.byIcon(Icons.highlight_off), findsNothing);

    await tester.enterText(cityField(), 'Miami');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.highlight_off));
    await tester.pump();

    expect(cityText(tester), isEmpty);
    expect(find.byIcon(Icons.highlight_off), findsNothing);
    verify(() => citySearchBloc.add(const CitySearchCleared())).called(1);
    verify(() => addCityBloc.add(const AddCityCityCleared())).called(1);
  });

  testWidgets('"Save City" is enabled when the form is valid and submits it',
      (tester) async {
    when(() => addCityBloc.state).thenReturn(
      const AddCityState(selectedCity: miami, description: 'My favorite city'),
    );
    await pumpSheet(tester);

    expect(saveButton(tester).onPressed, isNotNull);
    await tester.tap(find.text('Save City'));

    verify(() => addCityBloc.add(const AddCitySubmitted())).called(1);
  });

  testWidgets('shows an error when the city is already saved', (tester) async {
    when(() => addCityBloc.state).thenReturn(
      const AddCityState(
        selectedCity: miami,
        description: 'My favorite city',
        status: AddCityStatus.failure,
        error: CityAlreadySavedError(),
      ),
    );
    await pumpSheet(tester);

    expect(find.text('This city is already saved.'), findsOneWidget);
  });

  testWidgets('reloads the saved cities and closes the sheet once saved',
      (tester) async {
    final states = StreamController<AddCityState>();
    addTearDown(states.close);
    whenListen(
      addCityBloc,
      states.stream,
      initialState: const AddCityState(),
    );

    await tester.pumpWidget(
      withBlocs(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AddCitySheet(),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(AddCitySheet), findsOneWidget);

    states.add(
      const AddCityState(
        selectedCity: miami,
        description: 'My favorite city',
        status: AddCityStatus.saved,
      ),
    );
    await tester.pumpAndSettle();

    verify(() => savedCitiesBloc.add(const SavedCitiesRequested())).called(1);
    expect(find.byType(AddCitySheet), findsNothing);
  });
}
