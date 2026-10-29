/// Paths of the image assets declared in `pubspec.yaml`.
abstract final class AppImages {
  static const logo = 'assets/images/logo_app.png';
  static const noDataFound = 'assets/images/no_data_found_img.png';

  /// AccuWeather icon numbers that have an image (9, 10, 27 and 28 are not used).
  static const weatherIconNumbers = {
    1, 2, 3, 4, 5, 6, 7, 8, //
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, //
    29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44,
  };

  /// Path of the AccuWeather icon [number], e.g. 'assets/images/1.svg'.
  static String weatherIcon(int number) => 'assets/images/$number.svg';
}
