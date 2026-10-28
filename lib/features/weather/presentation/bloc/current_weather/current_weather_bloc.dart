import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/current_weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather.dart';

part 'current_weather_event.dart';
part 'current_weather_state.dart';

/// Loads the current weather of a single city card.
class CurrentWeatherBloc extends Bloc<CurrentWeatherEvent, CurrentWeatherState> {
  final GetCurrentWeather _getCurrentWeather;

  /// Fixed for the whole life of the bloc: one bloc per card.
  final String _locationKey;

  CurrentWeatherBloc({
    required this._getCurrentWeather,
    required this._locationKey,
  }) : super(const CurrentWeatherInitial()) {
    // Ignores new requests while one is in progress (e.g. tapping Retry twice).
    on<CurrentWeatherRequested>(_onRequested, transformer: droppable());
  }

  Future<void> _onRequested(
    CurrentWeatherRequested event,
    Emitter<CurrentWeatherState> emit,
  ) async {
    emit(const CurrentWeatherLoading());
    final result = await _getCurrentWeather(_locationKey);
    emit(
      result.when(
        onSuccess: CurrentWeatherSuccess.new,
        onFailure: CurrentWeatherError.new,
      ),
    );
  }
}
