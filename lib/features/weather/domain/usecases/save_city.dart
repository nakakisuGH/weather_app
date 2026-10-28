import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/repositories/saved_city_repository.dart';

class SaveCity {
  const SaveCity(this._savedCityRepository);

  final SavedCityRepository _savedCityRepository;

  Future<Result<void>> call(SavedCity savedCity) async {
    final savedCities = await _savedCityRepository.getSavedCities();
    final isAlreadySaved = savedCities.any(
      (saved) => saved.city.key == savedCity.city.key,
    );
    if (isAlreadySaved) {
      return const Failure(CityAlreadySavedError());
    }

    await _savedCityRepository.saveCity(savedCity);
    return const Success(null);
  }
}
