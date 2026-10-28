part of 'current_weather_bloc.dart';

sealed class CurrentWeatherState extends Equatable {
  const CurrentWeatherState();

  @override
  List<Object?> get props => [];
}

final class CurrentWeatherInitial extends CurrentWeatherState {
  const CurrentWeatherInitial();
}

final class CurrentWeatherLoading extends CurrentWeatherState {
  const CurrentWeatherLoading();
}

final class CurrentWeatherSuccess extends CurrentWeatherState {
  const CurrentWeatherSuccess(this.weather);

  final CurrentWeather weather;

  @override
  List<Object?> get props => [weather];
}

/// The card shows a Retry action in this state.
final class CurrentWeatherError extends CurrentWeatherState {
  const CurrentWeatherError(this.error);

  final AppError error;

  @override
  List<Object?> get props => [error];
}
