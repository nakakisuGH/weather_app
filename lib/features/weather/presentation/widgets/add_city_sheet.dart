import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/errors/app_error_message.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/domain/usecases/save_city.dart';
import 'package:weather_app/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_app/features/weather/presentation/bloc/add_city/add_city_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/city_search/city_search_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_description_field.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_search_field.dart';
import 'package:weather_app/features/weather/presentation/widgets/city_suggestions.dart';
import 'package:weather_app/features/weather/presentation/widgets/save_city_button.dart';

/// "Add City" bottom sheet: searches a city, takes a description and saves it.
///
/// It connects [CitySearchBloc] and [AddCityBloc] (the blocs don't know each
/// other) and reloads [SavedCitiesBloc] once the city is saved.
class AddCitySheet extends StatefulWidget {
  const AddCitySheet({super.key});

  /// Opens the sheet with its own blocs. They are created here and closed
  /// automatically when the sheet closes, so every opening starts empty.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CitySearchBloc(
              searchCities: sheetContext.read<SearchCities>(),
            ),
          ),
          BlocProvider(
            create: (_) => AddCityBloc(saveCity: sheetContext.read<SaveCity>()),
          ),
        ],
        child: const AddCitySheet(),
      ),
    );
  }

  @override
  State<AddCitySheet> createState() => _AddCitySheetState();
}

class _AddCitySheetState extends State<AddCitySheet> {
  /// Height of the area below the city field. The sheet keeps the
  /// same size whether it shows the description or the suggestions
  /// (room for 4 suggestions, as in the design).
  static const double _middleAreaHeight = 180;

  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCityChanged(String text) {
    context.read<CitySearchBloc>().add(CitySearchQueryChanged(text));
    final addCityBloc = context.read<AddCityBloc>();
    // The text no longer matches the selected city.
    if (addCityBloc.state.selectedCity != null) {
      addCityBloc.add(const AddCityCityCleared());
    }
  }

  void _onCitySelected(City city) {
    // Completes the text ("Mi" -> "Miami") and puts the cursor at the end.
    _cityController.value = TextEditingValue(
      text: city.name,
      selection: TextSelection.collapsed(offset: city.name.length),
    );
    context.read<AddCityBloc>().add(AddCityCitySelected(city));
    context.read<CitySearchBloc>().add(const CitySearchCleared());
  }

  void _onCityCleared() {
    _cityController.clear();
    context.read<CitySearchBloc>().add(const CitySearchCleared());
    context.read<AddCityBloc>().add(const AddCityCityCleared());
  }

  void _onDescriptionChanged(String text) {
    context.read<AddCityBloc>().add(AddCityDescriptionChanged(text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddCityBloc, AddCityState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AddCityStatus.saved,
      listener: (context, _) {
        context.read<SavedCitiesBloc>().add(const SavedCitiesRequested());
        Navigator.of(context).pop();
      },
      child: Padding(
        // Moves the sheet up when the keyboard opens.
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        // Scrolls only if the screen is too small for the whole sheet.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocSelector<AddCityBloc, AddCityState, String?>(
                selector: (state) => state.error?.userMessage,
                builder: (context, errorText) => CitySearchField(
                  controller: _cityController,
                  onChanged: _onCityChanged,
                  onClear: _onCityCleared,
                  errorText: errorText,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: _middleAreaHeight,
                // While a search is active, its result takes the description's place.
                child: BlocBuilder<CitySearchBloc, CitySearchState>(
                  builder: (context, state) => state is CitySearchInitial
                      ? SingleChildScrollView(
                          child: CityDescriptionField(
                            controller: _descriptionController,
                            onChanged: _onDescriptionChanged,
                          ),
                        )
                      : CitySuggestions(
                          state: state,
                          onSelected: _onCitySelected,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const SaveCityButton(),
            ],
          ),
        ),
      ),
    );
  }
}
