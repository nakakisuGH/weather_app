part of 'city_search_bloc.dart';

sealed class CitySearchState extends Equatable {
  const CitySearchState();

  @override
  List<Object?> get props => [];
}

/// Nothing to search yet (empty field or fewer than the minimum characters).
final class CitySearchInitial extends CitySearchState {
  const CitySearchInitial();
}

final class CitySearchLoading extends CitySearchState {
  const CitySearchLoading();
}

/// Search finished. An empty [cities] list means there were no matches.
final class CitySearchSuccess extends CitySearchState {
  const CitySearchSuccess(this.cities);

  final List<City> cities;

  @override
  List<Object?> get props => [cities];
}

/// Search failed. The user retries by editing or clearing the text.
final class CitySearchError extends CitySearchState {
  const CitySearchError(this.error);

  final AppError error;

  @override
  List<Object?> get props => [error];
}
