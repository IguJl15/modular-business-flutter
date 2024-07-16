import 'failure.dart';

abstract class ModelFailure<T> implements Failure {
  final Object error;
  final StackTrace stackTrace;

  const ModelFailure(this.error, this.stackTrace);
}

class RequestCreateModelFailure<T> implements ModelFailure<T> {
  @override
  final Object error;
  @override
  final StackTrace stackTrace;
  const RequestCreateModelFailure(this.error, this.stackTrace);

  @override
  String toErrorMessage() => 'Error when creating $T';
}

class RequestUpdateModelFailure<T> implements ModelFailure<T> {
  @override
  final Object error;
  @override
  final StackTrace stackTrace;
  const RequestUpdateModelFailure(this.error, this.stackTrace);

  @override
  String toErrorMessage() => 'Error when updating $T information';
}

class RequestGetModelFailure<T> implements ModelFailure<T> {
  @override
  final Object error;
  @override
  final StackTrace stackTrace;
  const RequestGetModelFailure(this.error, this.stackTrace);

  @override
  String toErrorMessage() => 'Error when getting $T information';
}
