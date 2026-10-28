import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';

/// DTO for a city returned by the AccuWeather autocomplete endpoint.
class CityModel extends Equatable {
  const CityModel({
    required this.key,
    required this.name,
    required this.country,
  });

  final String key;
  final String name;
  final String country;

  /// Creates a [CityModel] from a JSON map.
  /// Missing or null fields are replaced with empty strings.
  factory CityModel.fromJson(Map<String, dynamic> json) {
    final country = json['Country'] as Map<String, dynamic>?;

    return CityModel(
      key: json['Key'] as String? ?? '',
      name: json['LocalizedName'] as String? ?? '',
      country: country?['LocalizedName'] as String? ?? '',
    );
  }

  /// Converts this [CityModel] to a [City] entity.
  City toEntity() => City(
        key: key,
        name: name,
        country: country,
      );

  @override
  List<Object?> get props => [key, name, country];
}
