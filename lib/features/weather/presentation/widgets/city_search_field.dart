import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

/// "Add City" text field. Only reports what the user does: the parent
/// decides which events to send to the blocs.
class CitySearchField extends StatelessWidget {
  const CitySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the text changes, so the clear button only shows with text.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.fieldText,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: 'Add City',
          errorText: errorText,
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.highlight_off),
                  color: AppColors.textPrimary,
                  tooltip: 'Clear',
                  onPressed: onClear,
                ),
        ),
      ),
    );
  }
}
