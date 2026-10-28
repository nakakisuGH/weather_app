part of 'saved_cities_bloc.dart';

/// No error state: the list is read from memory and cannot fail (see README).
sealed class SavedCitiesState extends Equatable {
  const SavedCitiesState();

  @override
  List<Object?> get props => [];
}

final class SavedCitiesInitial extends SavedCitiesState {
  const SavedCitiesInitial();
}

final class SavedCitiesLoading extends SavedCitiesState {
  const SavedCitiesLoading();
}

/// An empty [savedCities] list means the Home shows its empty state.
final class SavedCitiesSuccess extends SavedCitiesState {
  const SavedCitiesSuccess(this.savedCities);

  final List<SavedCity> savedCities;

  @override
  List<Object?> get props => [savedCities];
}
