import 'failure.dart';

abstract class AuthFailure implements Failure {
  const AuthFailure();
}

class ExecutionErrorSignOutFailure implements AuthFailure {
  final Object error;
  final StackTrace stackTrace;
  const ExecutionErrorSignOutFailure(this.error, this.stackTrace);

  @override
  String toErrorMessage() => 'Error when making sign out request';
}

class AuthErrorLoginFailure implements AuthFailure {
  final String message;
  final String? statusCode;
  const AuthErrorLoginFailure(this.message, this.statusCode);

  @override
  String toErrorMessage() => message;
}

class ExecutionErrorLoginFailure implements AuthFailure {
  final Object error;
  final StackTrace stackTrace;
  const ExecutionErrorLoginFailure(this.error, this.stackTrace);

  @override
  String toErrorMessage() => 'Error when making login request';
}

class MissingUserIdLoginFailure implements AuthFailure {
  const MissingUserIdLoginFailure();

  @override
  String toErrorMessage() => 'Missing user information';
}

class RequestGetUserInformationFailure implements AuthFailure {
  final Object error;
  final StackTrace stackTrace;
  const RequestGetUserInformationFailure(this.error, this.stackTrace);

  @override
  toErrorMessage() => 'Error when getting user information';
}

class ResponseFormatErrorGetUserInformationFailure implements AuthFailure {
  final dynamic response;
  const ResponseFormatErrorGetUserInformationFailure(this.response);

  @override
  toErrorMessage() => 'Invalid response';
}

class JsonDecodeGetUserInformationFailure implements AuthFailure {
  final Map<String, dynamic> data;
  const JsonDecodeGetUserInformationFailure(this.data);

  @override
  toErrorMessage() => 'Missing valid user information';
}
