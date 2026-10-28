part of 'saved_cities_bloc.dart';

sealed class SavedCitiesEvent extends Equatable {
  const SavedCitiesEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the saved cities: when the Home opens and after a city is saved.
final class SavedCitiesRequested extends SavedCitiesEvent {
  const SavedCitiesRequested();
}
