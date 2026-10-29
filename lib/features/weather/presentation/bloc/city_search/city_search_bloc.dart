import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/utils/result.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';

part 'city_search_event.dart';
part 'city_search_state.dart';

/// Searches cities while the user types in the "Add City" sheet.
class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {

  final SearchCities _searchCities;
  final Duration _debounceDuration;

  CitySearchBloc({
    required this._searchCities,
    this._debounceDuration = const Duration(milliseconds: 400),
  }) : super(const CitySearchInitial()) {
    // Both events share one restartable() handler, so a clear also cancels
    // a search that is still waiting for the debounce.
    on<CitySearchEvent>(_onEvent, transformer: restartable());
  }

  Future<void> _onEvent(
    CitySearchEvent event,
    Emitter<CitySearchState> emit,
  ) async {
    switch (event) {
      case CitySearchQueryChanged(:final query):
        await _onQueryChanged(query, emit);
      case CitySearchCleared():
        emit(const CitySearchInitial());
    }
  }

  Future<void> _onQueryChanged(
    String rawQuery,
    Emitter<CitySearchState> emit,
  ) async {
    final query = rawQuery.trim();
    if (query.length < SearchCities.minQueryLength) {
      emit(const CitySearchInitial());
      return;
    }

    await Future<void>.delayed(_debounceDuration);
    // A newer query arrived while waiting: restartable() cancelled this one.
    if (emit.isDone) return;

    await _search(query, emit);
  }

  Future<void> _search(String query, Emitter<CitySearchState> emit) async {
    emit(const CitySearchLoading());
    final result = await _searchCities(query);
    emit(
      result.when(
        onSuccess: CitySearchSuccess.new,
        onFailure: CitySearchError.new,
      ),
    );
  }
}
