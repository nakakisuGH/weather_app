part of 'city_search_bloc.dart';

sealed class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object?> get props => [];
}

/// The user typed in the city search field.
final class CitySearchQueryChanged extends CitySearchEvent {
  const CitySearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// The suggestions are no longer needed (a city was selected or the sheet was closed).
final class CitySearchCleared extends CitySearchEvent {
  const CitySearchCleared();
}
