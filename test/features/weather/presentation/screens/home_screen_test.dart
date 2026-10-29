import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app/features/weather/presentation/screens/home_screen.dart';
import 'package:weather_app/features/weather/presentation/widgets/add_city_sheet.dart';

class MockSavedCitiesBloc extends MockBloc<SavedCitiesEvent, SavedCitiesState>
    implements SavedCitiesBloc {}

class MockSearchCities extends Mock implements SearchCities {}

class MockSaveCity extends Mock implements SaveCity {}

void main() {
  late MockSavedCitiesBloc savedCitiesBloc;

  setUp(() {
    savedCitiesBloc = MockSavedCitiesBloc();
  });

  /// Providers go above MaterialApp (as in the real app) so the "Add City"
  /// sheet's route can read them. The use cases are mocks: no real API calls.
  Future<void> pumpHome(WidgetTester tester, SavedCitiesState state) {
    when(() => savedCitiesBloc.state).thenReturn(state);
    return tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SearchCities>.value(value: MockSearchCities()),
          RepositoryProvider<SaveCity>.value(value: MockSaveCity()),
        ],
        child: BlocProvider<SavedCitiesBloc>.value(
          value: savedCitiesBloc,
          child: const MaterialApp(home: HomeScreen()),
        ),
      ),
    );
  }

  int selectedTab(WidgetTester tester) =>
      tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex;

  testWidgets('shows a loader while the cities are loading', (tester) async {
    await pumpHome(tester, const SavedCitiesLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('No data Found'), findsNothing);
  });

  testWidgets('shows the empty state when there are no saved cities',
      (tester) async {
    await pumpHome(tester, const SavedCitiesSuccess([]));

    expect(find.text('No data Found'), findsOneWidget);
    expect(
      find.text("Please add a city to track it's weather"),
      findsOneWidget,
    );
  });

  testWidgets('shows the title, the add button and the bottom navigation',
      (tester) async {
    await pumpHome(tester, const SavedCitiesSuccess([]));

    expect(find.text('WeatherForemost'), findsOneWidget);
    expect(
      find.widgetWithIcon(FloatingActionButton, Icons.add),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(selectedTab(tester), 1);
  });

  testWidgets('opens the Add City sheet when + is tapped', (tester) async {
    await pumpHome(tester, const SavedCitiesSuccess([]));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AddCitySheet), findsOneWidget);
    expect(find.text('Save City'), findsOneWidget);
  });

  testWidgets('keeps Locations selected when Home or Profile is tapped',
      (tester) async {
    await pumpHome(tester, const SavedCitiesSuccess([]));

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pump();
    expect(selectedTab(tester), 1);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pump();
    expect(selectedTab(tester), 1);
  });
}
