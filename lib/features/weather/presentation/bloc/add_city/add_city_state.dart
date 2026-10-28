part of 'add_city_bloc.dart';

/// Maps to the Initial / Loading / Success / Error states of the form.
enum AddCityStatus { editing, saving, saved, failure }

final class AddCityState extends Equatable {
  const AddCityState({
    this.selectedCity,
    this.description = '',
    this.status = AddCityStatus.editing,
    this.error,
  });

  final City? selectedCity;
  final String description;
  final AddCityStatus status;

  /// Only set when [status] is [AddCityStatus.failure].
  final AppError? error;

  /// Whether the "Save City" button is enabled.
  bool get canSave =>
      selectedCity != null &&
      description.trim().isNotEmpty &&
      status != AddCityStatus.saving;

  /// [error] is not kept on purpose: any change clears the previous error.
  AddCityState copyWith({
    City? selectedCity,
    String? description,
    AddCityStatus? status,
    AppError? error,
  }) {
    return AddCityState(
      selectedCity: selectedCity ?? this.selectedCity,
      description: description ?? this.description,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedCity, description, status, error];
}
