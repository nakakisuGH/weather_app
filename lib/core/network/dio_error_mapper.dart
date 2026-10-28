import 'package:dio/dio.dart';
import 'package:weather_app/core/errors/app_error.dart';

/// Converts a [DioException] into the matching [AppError].
AppError mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutError();
    case DioExceptionType.connectionError:
      return const NoConnectionError();
    case DioExceptionType.badResponse:
      return _mapBadResponse(exception.response);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return UnknownError(exception.message ?? '');
  }
}

AppError _mapBadResponse(Response<dynamic>? response) {
  final statusCode = response?.statusCode ?? 0;
  final body = response?.data;
  final message =
      body is Map<String, dynamic> ? body['Message'] as String? ?? '' : '';

  return switch (statusCode) {
    400 => const BadRequestError(),
    401 || 403 => const UnauthorizedError(),
    404 => const NotFoundError(),
    >= 500 => ServerError(statusCode: statusCode, message: message),
    _ => UnknownError('HTTP $statusCode: $message'),
  };
}
