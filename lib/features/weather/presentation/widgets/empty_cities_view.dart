import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_images.dart';
import 'package:weather_app/core/theme/app_text_styles.dart';

/// Shown in the Home when there are no saved cities.
class EmptyCitiesView extends StatelessWidget {
  const EmptyCitiesView({super.key});

  /// The illustration takes this fraction of the available width...
  static const double _imageWidthFactor = 0.3;

  /// ...but never grows beyond this size (tablets, landscape).
  static const double _maxImageWidth = 100;

  static const _noExtraLineSpace = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = math.min(
          constraints.maxWidth * _imageWidthFactor,
          _maxImageWidth,
        );

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImages.noDataFound, width: imageWidth),
                const SizedBox(height: 16),
                SizedBox(
                  width: imageWidth,
                  child: const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'No data Found',
                      style: AppTextStyles.emptyTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      textHeightBehavior: _noExtraLineSpace
                    )
                  )
                ),
                const SizedBox(height: 4),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Please add a city to track it's weather",
                    style: AppTextStyles.emptyMessage,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    textHeightBehavior: _noExtraLineSpace
                  ), 
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
