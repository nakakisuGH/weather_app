import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/city_model.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';

void main() {
  const miami = CityModel(
    key: '347936',
    name: 'Miami',
    country: 'United States',
  );

  group('CityModel.fromJson', () {
    test('parses a complete autocomplete item', () {
      final json = jsonDecode('''
        {
          "Version": 1,
          "Key": "347936",
          "Type": "City",
          "Rank": 15,
          "LocalizedName": "Miami",
          "Country": { "ID": "US", "LocalizedName": "United States" },
          "AdministrativeArea": { "ID": "FL", "LocalizedName": "Florida" }
        }
      ''') as Map<String, dynamic>;

      expect(CityModel.fromJson(json), miami);
    });

    test('uses an empty country when Country is missing', () {
      final model = CityModel.fromJson({
        'Key': '347936',
        'LocalizedName': 'Miami',
      });

      expect(
        model,
        const CityModel(key: '347936', name: 'Miami', country: ''),
      );
    });

    test('uses an empty country when Country has no LocalizedName', () {
      final model = CityModel.fromJson({
        'Key': '347936',
        'LocalizedName': 'Miami',
        'Country': {'ID': 'US'},
      });

      expect(model.country, '');
    });

    test('uses empty strings when all fields are missing', () {
      expect(
        CityModel.fromJson({}),
        const CityModel(key: '', name: '', country: ''),
      );
    });

    test('uses empty strings when fields are null', () {
      final model = CityModel.fromJson({
        'Key': null,
        'LocalizedName': null,
        'Country': null,
      });

      expect(model, const CityModel(key: '', name: '', country: ''));
    });
  });

  group('CityModel.toEntity', () {
    test('maps every field to a City entity', () {
      expect(
        miami.toEntity(),
        const City(key: '347936', name: 'Miami', country: 'United States'),
      );
    });
  });
}
