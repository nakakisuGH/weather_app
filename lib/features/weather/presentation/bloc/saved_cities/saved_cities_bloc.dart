import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/get_saved_cities.dart';

part 'saved_cities_event.dart';
part 'saved_cities_state.dart';

/// Provides the list of saved cities shown in the Home.
class SavedCitiesBloc extends Bloc<SavedCitiesEvent, SavedCitiesState> {
  final GetSavedCities _getSavedCities;

  SavedCitiesBloc({required this._getSavedCities})
      : super(const SavedCitiesInitial()) {
    on<SavedCitiesRequested>(_onRequested);
  }

  Future<void> _onRequested(
    SavedCitiesRequested event,
    Emitter<SavedCitiesState> emit,
  ) async {
    // When reloading, the current list stays visible instead of flashing a loader.
    if (state is! SavedCitiesSuccess) emit(const SavedCitiesLoading());
    emit(SavedCitiesSuccess(await _getSavedCities()));
  }
}
