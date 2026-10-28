import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/repositories/saved_city_repository.dart';

class GetSavedCities {
  const GetSavedCities(this._savedCityRepository);

  final SavedCityRepository _savedCityRepository;

  Future<List<SavedCity>> call() => _savedCityRepository.getSavedCities();
}
