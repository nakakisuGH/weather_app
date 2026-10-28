import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/data/datasources/city_remote_data_source.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/repositories/city_repository.dart';

/// [CityRepository] backed by the AccuWeather autocomplete endpoint.
class CityRepositoryImpl implements CityRepository {
  const CityRepositoryImpl(this._cityRemoteDataSource);

  final CityRemoteDataSource _cityRemoteDataSource;

  @override
  Future<Result<List<City>>> searchCities(String query) async {
    try {
      final cityModels = await _cityRemoteDataSource.searchCities(query);
      return Success(cityModels.map((cityModel) => cityModel.toEntity()).toList());
    } on AppError catch (error) {
      return Failure(error);
    }
  }
}
