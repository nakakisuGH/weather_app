import 'package:equatable/equatable.dart';

sealed class AppError extends Equatable implements Exception {
  const AppError();

  @override
  List<Object?> get props => [];
}

/// HTTP 400: bad request.
final class BadRequestFailure extends AppError {
  const BadRequestFailure();
}

/// HTTP 401: unauthorized.
final class UnauthorizedFailure extends AppError {
  const UnauthorizedFailure();
}

/// HTTP 404: resource not found.
final class NotFoundFailure extends AppError {
  const NotFoundFailure();
}

/// HTTP 408: request timeout.
final class TimeoutFailure extends AppError {
  const TimeoutFailure();
}

/// HTTP 500: internal server error.
final class ServerFailure extends AppError {
  const ServerFailure();
}

/// Represents a failure due to no internet connection.
final class NoConnectionFailure extends AppError {
  const NoConnectionFailure();
}

/// Represents a failure due to an unknown error.
final class UnknownFailure extends AppError {
  const UnknownFailure();
}

/// Represents a failure when trying to save a city that is already saved.
final class CityAlreadySavedFailure extends AppError {
  const CityAlreadySavedFailure();
}
