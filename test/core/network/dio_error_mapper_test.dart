import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/errors/app_error.dart';
import 'package:weather_app/core/network/dio_error_mapper.dart';

void main() {
  DioException exceptionOfType(DioExceptionType type) =>
      DioException(requestOptions: RequestOptions(), type: type);

  DioException badResponse(int statusCode, {Object? data}) => DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(),
          statusCode: statusCode,
          data: data,
        ),
      );

  group('mapDioException', () {
    test('maps every timeout type to TimeoutError', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ]) {
        expect(mapDioException(exceptionOfType(type)), const TimeoutError());
      }
    });

    test('maps connectionError to NoConnectionError', () {
      expect(
        mapDioException(exceptionOfType(DioExceptionType.connectionError)),
        const NoConnectionError(),
      );
    });

    test('maps 400 to BadRequestError', () {
      expect(mapDioException(badResponse(400)), const BadRequestError());
    });

    test('maps 401 and 403 to UnauthorizedError', () {
      expect(mapDioException(badResponse(401)), const UnauthorizedError());
      expect(mapDioException(badResponse(403)), const UnauthorizedError());
    });

    test('maps 404 to NotFoundError', () {
      expect(mapDioException(badResponse(404)), const NotFoundError());
    });

    test('maps 5xx to ServerError with the status code and body message', () {
      expect(
        mapDioException(
          badResponse(500, data: {'Message': 'Internal server error.'}),
        ),
        const ServerError(statusCode: 500, message: 'Internal server error.'),
      );
      expect(
        mapDioException(
          badResponse(503, data: {'Message': 'Requests exceeded.'}),
        ),
        const ServerError(statusCode: 503, message: 'Requests exceeded.'),
      );
    });

    test('maps 5xx without a body to ServerError with an empty message', () {
      expect(
        mapDioException(badResponse(500)),
        const ServerError(statusCode: 500),
      );
    });

    test('maps an unexpected status code to UnknownError', () {
      expect(mapDioException(badResponse(418)), isA<UnknownError>());
    });

    test('maps cancel to UnknownError', () {
      expect(
        mapDioException(exceptionOfType(DioExceptionType.cancel)),
        isA<UnknownError>(),
      );
    });
  });
}
