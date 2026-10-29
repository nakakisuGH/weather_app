import 'package:weather_app/core/errors/app_error.dart';

/// Text shown to the user for each [AppError].
///
/// Named `userMessage` (not `message`) because [ServerError] and [UnknownError]
/// already have a `message` field, which would hide an extension getter.
extension AppErrorMessage on AppError {
  String get userMessage => switch (this) {
        NoConnectionError() => 'No internet connection.',
        TimeoutError() => 'The request took too long.',
        UnauthorizedError() => 'Invalid API key.',
        BadRequestError() => 'Invalid request.',
        NotFoundError() => 'Not found.',
        ServerError() => 'Server error. Please try again later.',
        CityAlreadySavedError() => 'This city is already saved.',
        UnknownError() => 'Something went wrong.',
      };
}
