import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/entities/saved_city.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';

part 'add_city_event.dart';
part 'add_city_state.dart';

/// Handles the "Add City" form: selected city, description and saving.
class AddCityBloc extends Bloc<AddCityEvent, AddCityState> {
  final SaveCity _saveCity;

  AddCityBloc({required this._saveCity}) : super(const AddCityState()) {
    on<AddCityCitySelected>(
      (event, emit) => emit(
        state.copyWith(selectedCity: event.city, status: AddCityStatus.editing),
      ),
    );
    // A new state instead of copyWith, because copyWith cannot set a field back to null.
    on<AddCityCityCleared>(
      (_, emit) => emit(AddCityState(description: state.description)),
    );
    on<AddCityDescriptionChanged>(
      (event, emit) => emit(
        state.copyWith(
          description: event.description,
          status: AddCityStatus.editing,
        ),
      ),
    );
    on<AddCitySubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    AddCitySubmitted event,
    Emitter<AddCityState> emit,
  ) async {
    final city = state.selectedCity;
    if (city == null || !state.canSave) return;

    emit(state.copyWith(status: AddCityStatus.saving));
    final result = await _saveCity(
      SavedCity(city: city, description: state.description.trim()),
    );
    emit(
      result.when(
        onSuccess: (_) => state.copyWith(status: AddCityStatus.saved),
        onFailure: (error) =>
            state.copyWith(status: AddCityStatus.failure, error: error),
      ),
    );
  }
}
