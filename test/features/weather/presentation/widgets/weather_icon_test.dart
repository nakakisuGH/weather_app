import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/constants/app_images.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_icon.dart';

void main() {
  Future<void> pumpIcon(WidgetTester tester, int number) =>
      tester.pumpWidget(MaterialApp(home: WeatherIcon(number)));

  String? svgAssetName(WidgetTester tester) {
    final loader = tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader;
    return loader is SvgAssetLoader ? loader.assetName : null;
  }

  for (final number in [1, 33, 44]) {
    testWidgets('icon $number shows its AccuWeather SVG', (tester) async {
      await pumpIcon(tester, number);

      expect(svgAssetName(tester), 'assets/images/$number.svg');
    });
  }

  for (final number in [0, 9, 99]) {
    testWidgets('icon $number has no image and shows the fallback icon',
        (tester) async {
      await pumpIcon(tester, number);

      expect(find.byType(SvgPicture), findsNothing);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });
  }

  test('every icon number has its SVG file in assets/images', () {
    final missing = AppImages.weatherIconNumbers
        .map(AppImages.weatherIcon)
        .where((path) => !File(path).existsSync())
        .toList();

    expect(missing, isEmpty);
  });
}
