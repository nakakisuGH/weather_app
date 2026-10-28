import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/repositories/saved_city_repository.dart';

/// [SavedCityRepository] that keeps the saved cities in memory.
/// They are lost when the app is closed.
class InMemorySavedCityRepository implements SavedCityRepository {
  final List<SavedCity> _savedCities = [];

  @override
  Future<List<SavedCity>> getSavedCities() async =>
      List.unmodifiable(_savedCities);

  @override
  Future<void> saveCity(SavedCity savedCity) async {
    _savedCities.add(savedCity);
  }
}
