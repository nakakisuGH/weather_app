import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/core/utils/result.dart';

abstract interface class CityRepository {
  /// Searches for cities matching the given [query].
  /// Returns a list of [City] objects if successful, or a [Failure] if an error occurs.
  Future<Result<List<City>>> searchCities(String query);
}
