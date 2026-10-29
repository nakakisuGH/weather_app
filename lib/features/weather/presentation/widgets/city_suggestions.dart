import 'package:flutter/material.dart';
import 'package:weather_app/core/errors/app_error_message.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';
import 'package:weather_app/features/weather/domain/entities/city.dart';
import 'package:weather_app/features/weather/presentation/bloc/city_search/city_search_bloc.dart';

/// Result of the city search: loader, suggestions, "no results" or error.
class CitySuggestions extends StatelessWidget {
  const CitySuggestions({
    super.key,
    required this.state,
    required this.onSelected,
  });

  final CitySearchState state;
  final ValueChanged<City> onSelected;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      CitySearchInitial() => const SizedBox.shrink(),
      CitySearchLoading() => const Center(child: CircularProgressIndicator()),
      CitySearchSuccess(:final cities) when cities.isEmpty =>
        const _SearchMessage('No cities found'),
      CitySearchSuccess(:final cities) => ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: cities.length,
          itemBuilder: (context, index) {
            final city = cities[index];
            return InkWell(
              onTap: () => onSelected(city),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(city.name, style: AppTextStyles.suggestion),
              ),
            );
          },
        ),
      // No Retry button: editing or clearing the text searches again (see README).
      CitySearchError(:final error) =>
        _SearchMessage('${error.userMessage}\nEdit the text to try again.'),
    };
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.searchMessage,
        textAlign: TextAlign.center,
      ),
    );
  }
}
