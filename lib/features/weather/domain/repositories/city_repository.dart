import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/core/utils/result.dart';

abstract interface class CityRepository {
  /// Searches for cities matching the given [query].
  /// Returns [Success] with the matching cities, or [Failed] with a [Failure].
  Future<Result<List<City>>> searchCities(String query);
}
