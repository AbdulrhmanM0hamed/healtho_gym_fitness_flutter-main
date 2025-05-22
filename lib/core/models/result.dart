import 'package:healtho_gym/core/models/app_exception.dart';

class Result<T> {
  final T? _data;
  final AppException? _error;

  Result._({T? data, AppException? error})
      : _data = data,
        _error = error;

  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppException error) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  void when({
    required Function(T data) success,
    required Function(AppException error) failure,
  }) {
    if (this is Success<T>) {
      success(_data as T);
    } else if (this is Failure<T>) {
      failure(_error!);
    }
  }

  R fold<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    if (this is Success<T>) {
      return success(_data as T);
    } else {
      return failure(_error!);
    }
  }
}

class Success<T> extends Result<T> {
  Success(T data) : super._(data: data);
}

class Failure<T> extends Result<T> {
  Failure(AppException error) : super._(error: error);
} 