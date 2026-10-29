import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/presentation/bloc/add_city/add_city_bloc.dart';

/// "Save City" button. Disabled (grey) until [AddCityState.canSave] is true.
class SaveCityButton extends StatelessWidget {
  const SaveCityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCityBloc, AddCityState>(
      buildWhen: (previous, current) => previous.canSave != current.canSave,
      builder: (context, state) => FilledButton(
        // A null onPressed is how Flutter disables a button.
        onPressed: state.canSave
            ? () => context.read<AddCityBloc>().add(const AddCitySubmitted())
            : null,
        child: const Text('Save City'),
      ),
    );
  }
}
