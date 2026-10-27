import 'package:equatable/equatable.dart';

/// The current weather of the city, returned by the current conditions API.

class CurrentWeather extends Equatable {
  final DateTime localObservationTime;
  final int weatherIcon;
  final String weatherText;

  const CurrentWeather({
    required this.localObservationTime,  /// Time in the city's local time (not the device's) 
    required this.weatherIcon,
    required this.weatherText,
  });

  @override
  List<Object?> get props => [localObservationTime, weatherIcon, weatherText];
}
