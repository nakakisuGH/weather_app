import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

void main() {
  final sunnyAtEleven = CurrentWeatherModel(
    localObservationTime: DateTime(2026, 10, 26, 11),
    weatherIcon: 1,
    weatherText: 'Sunny',
  );

  const emptyModel = CurrentWeatherModel(
    localObservationTime: null,
    weatherIcon: 0,
    weatherText: '',
  );

  group('CurrentWeatherModel.fromJson', () {
    test('parses a complete current conditions item', () {
      final json = jsonDecode('''
        {
          "LocalObservationDateTime": "2026-10-26T11:00:00-04:00",
          "EpochTime": 1793026800,
          "WeatherText": "Sunny",
          "WeatherIcon": 1,
          "HasPrecipitation": false,
          "PrecipitationType": null,
          "IsDayTime": true,
          "Temperature": {
            "Metric": { "Value": 27.8, "Unit": "C", "UnitType": 17 }
          }
        }
      ''') as Map<String, dynamic>;

      expect(CurrentWeatherModel.fromJson(json), sunnyAtEleven);
    });

    test("keeps the city's local time whatever the UTC offset is", () {
      final model = CurrentWeatherModel.fromJson({
        'LocalObservationDateTime': '2026-10-26T11:00:00+09:00',
      });

      expect(model.localObservationTime?.hour, 11);
      expect(model.localObservationTime?.minute, 0);
    });

    test('returns a null time when LocalObservationDateTime is missing', () {
      final model = CurrentWeatherModel.fromJson({
        'WeatherIcon': 1,
        'WeatherText': 'Sunny',
      });

      expect(model.localObservationTime, isNull);
    });

    test('returns a null time when the date has an invalid format', () {
      final model = CurrentWeatherModel.fromJson({
        'LocalObservationDateTime': 'invalid-date-time-value',
      });

      expect(model.localObservationTime, isNull);
    });

    test('returns a null time when the date is too short', () {
      final model = CurrentWeatherModel.fromJson({
        'LocalObservationDateTime': '11:00',
      });

      expect(model.localObservationTime, isNull);
    });

    test('uses safe defaults when all fields are missing', () {
      expect(CurrentWeatherModel.fromJson({}), emptyModel);
    });

    test('uses safe defaults when fields are null', () {
      final model = CurrentWeatherModel.fromJson({
        'LocalObservationDateTime': null,
        'WeatherIcon': null,
        'WeatherText': null,
      });

      expect(model, emptyModel);
    });
  });

  group('CurrentWeatherModel.toEntity', () {
    test('maps every field to a CurrentWeather entity', () {
      expect(
        sunnyAtEleven.toEntity(),
        CurrentWeather(
          localObservationTime: DateTime(2026, 10, 26, 11),
          weatherIcon: 1,
          weatherText: 'Sunny',
        ),
      );
    });

    test('keeps a null observation time', () {
      expect(
        emptyModel.toEntity(),
        const CurrentWeather(
          localObservationTime: null,
          weatherIcon: 0,
          weatherText: '',
        ),
      );
    });
  });
}
