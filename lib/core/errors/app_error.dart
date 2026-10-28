import 'package:equatable/equatable.dart';

/// Errors the app can produce, are represented by this class and its subclasses. 
/// Each subclass represents a specific type of error that can occur in the app.
/// This allows for a consistent way to handle errors throughout the app.

sealed class AppError extends Equatable implements Exception {
  const AppError();

  @override
  List<Object?> get props => [];
}

/// HTTP 400: bad request.
final class BadRequestError extends AppError {
  const BadRequestError();
}

/// HTTP 401: unauthorized. The API key is invalid or missing.
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
  const ServerError({required this.statusCode, this.message = ''});
  
  @override
  List<Object?> get props => [statusCode, message];
}

/// Represents a failure due to no internet connection.
final class NoConnectionError extends AppError {
  const NoConnectionError();
}

/// Represents a failure due to an unknown error.
final class UnknownError extends AppError {
  const UnknownError([this.message = '']);
  final String message;

  @override
  List<Object?> get props => [message];
}

///The request timed out (connection, send or receive) before the server responded.
final class TimeoutError extends AppError {
  const TimeoutError();
}

/// Represents a failure when trying to save a city that is already saved.
final class CityAlreadySavedError extends AppError {
  const CityAlreadySavedError();
}
