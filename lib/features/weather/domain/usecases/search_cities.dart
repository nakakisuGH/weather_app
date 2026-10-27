import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/repositories/city_repository.dart';

class SearchCities {
  const SearchCities({required this._cityRepository});

  /// Minimum number of characters before querying the API.
  static const int minQueryLength = 2;

  final CityRepository _cityRepository;

  Future<Result<List<City>>> call(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.length < minQueryLength) {
      return const Success([]);
    }
    return _cityRepository.searchCities(trimmedQuery);
  }
}