import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/weather_app.dart';

class MockSearchCities extends Mock implements SearchCities {}

class MockGetCurrentWeather extends Mock implements GetCurrentWeather {}

class MockSaveCity extends Mock implements SaveCity {}

class MockGetSavedCities extends Mock implements GetSavedCities {}

void main() {
  late MockGetSavedCities getSavedCities;

  setUp(() {
    getSavedCities = MockGetSavedCities();
    when(() => getSavedCities()).thenAnswer((_) async => <SavedCity>[]);
  });

  Future<void> pumpApp(WidgetTester tester) => tester.pumpWidget(
        WeatherApp(
          searchCities: MockSearchCities(),
          getCurrentWeather: MockGetCurrentWeather(),
          saveCity: MockSaveCity(),
          getSavedCities: getSavedCities,
        ),
      );

  testWidgets('renders the app', (tester) async {
    await pumpApp(tester);

    expect(find.text('WeatherForemost'), findsOneWidget);
  });

  testWidgets('loads the saved cities on startup', (tester) async {
    await pumpApp(tester);

    verify(() => getSavedCities()).called(1);
  });
}
