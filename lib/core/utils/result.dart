import 'package:weather_app/core/errors/app_error.dart';
import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

final class Failure<T> extends Result<T> {
  const Failure(this.appError);
  final AppError appError;

  @override
  List<Object?> get props => [appError];
}

extension ResultExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError appError) onFailure,
  }) {
    return switch (this){
      Success(:final data) => onSuccess(data),
      Failure(:final appError) => onFailure(appError),
    };
  }
}
