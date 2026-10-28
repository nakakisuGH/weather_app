part of 'current_weather_bloc.dart';

sealed class CurrentWeatherEvent extends Equatable {
  const CurrentWeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the weather: when the card is created and when Retry is tapped.
final class CurrentWeatherRequested extends CurrentWeatherEvent {
  const CurrentWeatherRequested();
}
