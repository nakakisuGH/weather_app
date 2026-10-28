import 'package:equatable/equatable.dart';

/// The current weather of the city, returned by the current conditions API.
class CurrentWeather extends Equatable {
  /// Observation time in the city's local time (not the device's).
  /// Null if the API did not send a valid value.
  final DateTime? localObservationTime;
  final int weatherIcon;
  final String weatherText;

  const CurrentWeather({
    required this.localObservationTime,
    required this.weatherIcon,
    required this.weatherText,
  });

  @override
  List<Object?> get props => [localObservationTime, weatherIcon, weatherText];
}
