part of 'add_city_bloc.dart';

sealed class AddCityEvent extends Equatable {
  const AddCityEvent();

  @override
  List<Object?> get props => [];
}

/// The user tapped a city in the suggestions list.
final class AddCityCitySelected extends AddCityEvent {
  const AddCityCitySelected(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

/// The selected city is no longer valid (the text was edited or cleared).
final class AddCityCityCleared extends AddCityEvent {
  const AddCityCityCleared();
}

/// The user typed in the description field.
final class AddCityDescriptionChanged extends AddCityEvent {
  const AddCityDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

/// The user tapped "Save City".
final class AddCitySubmitted extends AddCityEvent {
  const AddCitySubmitted();
}
