import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/saved_cities/saved_cities_bloc.dart';
import 'package:weather_app/features/weather/presentation/widgets/add_city_sheet.dart';
import 'package:weather_app/features/weather/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:weather_app/features/weather/presentation/widgets/empty_cities_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_app_top_bar.dart';

/// Home screen: the list of saved cities, or the empty state when there are none.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WeatherAppTopBar(),
      body: BlocBuilder<SavedCitiesBloc, SavedCitiesState>(
        builder: (context, state) => switch (state) {
          SavedCitiesInitial() || SavedCitiesLoading() =>
            const Center(child: CircularProgressIndicator()),
          SavedCitiesSuccess(:final savedCities) when savedCities.isEmpty =>
            const EmptyCitiesView(),
          SavedCitiesSuccess(:final savedCities) => ListView.builder(
              itemCount: savedCities.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(savedCities[index].city.name)),
            ),
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () => AddCitySheet.show(context),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
    
  }
}
