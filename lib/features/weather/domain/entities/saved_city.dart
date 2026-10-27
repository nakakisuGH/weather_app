import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';

/// A city saved by the user, with a custom description.
class SavedCity extends Equatable {
  final City city;
  final String description;

  const SavedCity({
    required this.city,
    required this.description,
  });

  @override
  List<Object?> get props => [city, description];
}
