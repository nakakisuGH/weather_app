import 'package:equatable/equatable.dart';

/// A city suggestion returned by the location search API.
class City extends Equatable {
  final String key;
  final String name;
  final String country;

  const City({
    required this.key,
    required this.name,
    required this.country,
  });

  @override
  List<Object?> get props => [key, name, country];
}
