import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';

/// DTO for one element of the AccuWeather current conditions response.
class CurrentWeatherModel extends Equatable {
  const CurrentWeatherModel({
    required this.localObservationTime,
    required this.weatherIcon,
    required this.weatherText,
  });

  /// Wall-clock time of the observation in the city's time zone.
  final DateTime? localObservationTime;

  /// AccuWeather icon number (1-44), or 0 when missing.
  final int weatherIcon;

  final String weatherText;

  /// Parses only the "yyyy-MM-ddTHH:mm:ss" part and ignores the UTC offset,
  /// so 11:00 in Miami stays 11:00 whatever the device's time zone is.
  /// Returns null if [value] is missing or not a valid date.
  static DateTime? _parseLocalDateTime(String? value) {
    const localDateTimeLength = 19;
    if (value == null || value.length < localDateTimeLength) {
      return null;
    }
    return DateTime.tryParse(value.substring(0, localDateTimeLength));
  }

  /// Creates a [CurrentWeatherModel] from a JSON map.
  /// Missing or invalid fields fall back to safe defaults.
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      localObservationTime: _parseLocalDateTime(
        json['LocalObservationDateTime'] as String?,
      ),
      weatherIcon: json['WeatherIcon'] as int? ?? 0,
      weatherText: json['WeatherText'] as String? ?? '',
    );
  }

  /// Converts this [CurrentWeatherModel] to a [CurrentWeather] entity.
  CurrentWeather toEntity() => CurrentWeather(
        localObservationTime: localObservationTime,
        weatherIcon: weatherIcon,
        weatherText: weatherText,
      );

  @override
  List<Object?> get props => [localObservationTime, weatherIcon, weatherText];
}
