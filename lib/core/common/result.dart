import 'exception.dart';

sealed class Result<T> {
  factory Result.success({required T data}) = ResultSuccess;

  factory Result.error({T? data, required AppException error}) = ResultError;
}

final class ResultSuccess<T> implements Result<T> {
  final T data;

  ResultSuccess({required this.data});
}

final class ResultError<T> implements Result<T> {
  final T? data;
  final AppException error;

  ResultError({this.data, required this.error});
}
