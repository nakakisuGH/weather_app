import 'package:weather_app/features/weather/domain/entities/saved_city.dart';

abstract interface class SavedCityRepository {
  /// Returns all cities saved by the user.
  Future<List<SavedCity>> getSavedCities();

  /// Stores [savedCity]. Does not check for duplicates.
  Future<void> saveCity(SavedCity savedCity);
}
