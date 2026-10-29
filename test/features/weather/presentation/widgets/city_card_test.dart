import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/presentation/bloc/current_weather/current_weather_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_card.dart';

class MockCurrentWeatherBloc
    extends MockBloc<CurrentWeatherEvent, CurrentWeatherState>
    implements CurrentWeatherBloc {}

void main() {
  late MockCurrentWeatherBloc currentWeatherBloc;

  const miami = SavedCity(
    city: City(key: '347936', name: 'Miami', country: 'United States'),
    description: 'This is my favorite city.',
  );

  setUp(() {
    currentWeatherBloc = MockCurrentWeatherBloc();
  });

  Future<void> pumpCard(WidgetTester tester, CurrentWeatherState state) {
    when(() => currentWeatherBloc.state).thenReturn(state);
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: BlocProvider<CurrentWeatherBloc>.value(
            value: currentWeatherBloc,
            child: const CityCard(savedCity: miami),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the name and up to two lines of description',
      (tester) async {
    await pumpCard(tester, const CurrentWeatherLoading());

    expect(find.text('Miami'), findsOneWidget);
    final description =
        tester.widget<Text>(find.text('This is my favorite city.'));
    expect(description.maxLines, 2);
    expect(description.overflow, TextOverflow.ellipsis);
  });

  testWidgets('shows a loader while the weather is loading', (tester) async {
    await pumpCard(tester, const CurrentWeatherLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows the weather icon and the local time', (tester) async {
    await pumpCard(
      tester,
      CurrentWeatherSuccess(
        CurrentWeather(
          localObservationTime: DateTime(2026, 10, 29, 11),
          weatherIcon: 1,
          weatherText: 'Sunny',
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('11:00 AM'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows Retry on error and requests the weather again',
      (tester) async {
    await pumpCard(tester, const CurrentWeatherError(NoConnectionError()));

    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.refresh));

    verify(() => currentWeatherBloc.add(const CurrentWeatherRequested()))
        .called(1);
  });
}
