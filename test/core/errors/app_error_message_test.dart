import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/errors/app_error_message.dart';

void main() {
  // Not const: Equatable overrides ==, which const map keys don't allow.
  final messages = <AppError, String>{
    NoConnectionError(): 'No internet connection.',
    TimeoutError(): 'The request took too long.',
    UnauthorizedError(): 'Invalid API key.',
    BadRequestError(): 'Invalid request.',
    NotFoundError(): 'Not found.',
    ServerError(statusCode: 500): 'Server error. Please try again later.',
    CityAlreadySavedError(): 'This city is already saved.',
    UnknownError(): 'Something went wrong.',
  };

  for (final MapEntry(key: error, value: message) in messages.entries) {
    test('${error.runtimeType} has a user message', () {
      expect(error.userMessage, message);
    });
  }
}
