import 'package:equatable/equatable.dart';

sealed class AppError extends Equatable implements Exception {
  const AppError();

  @override
  List<Object?> get props => [];
}

/// HTTP 400: bad request.
final class BadRequestError extends AppError {
  const BadRequestError();
}

/// HTTP 401: unauthorized.
final class UnauthorizedError extends AppError {
  const UnauthorizedError();
}

/// HTTP 404: resource not found.
final class NotFoundError extends AppError {
  const NotFoundError();
}

/// HTTP 500: internal server error.
final class ServerError extends AppError {
  final int statusCode;
  final String message;
  const ServerError({required this.statusCode, required this.message});
}

/// Represents a failure due to no internet connection.
final class NoConnectionError extends AppError {
  const NoConnectionError();
}

/// Represents a failure due to an unknown error.
final class UnknownError extends AppError {
  const UnknownError(this.message);
  final String message;
}

/// Represents a failure when trying to save a city that is already saved.
final class CityAlreadySavedError extends AppError {
  const CityAlreadySavedError();
}
