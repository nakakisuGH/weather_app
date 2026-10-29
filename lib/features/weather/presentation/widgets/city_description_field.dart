import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

/// Multi-line "Description" field of the "Add City" sheet.
class CityDescriptionField extends StatelessWidget {
  const CityDescriptionField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  /// Owned by the sheet, so the text survives while the suggestions
  /// temporarily take this field's place.
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const int _lines = 4;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.fieldText,
      minLines: _lines,
      maxLines: _lines,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Add a description',
        alignLabelWithHint: true,
      ),
    );
  }
}
