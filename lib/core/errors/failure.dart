abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    required super.message,
    super.statusCode,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.statusCode,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    required super.message,
    super.statusCode,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.statusCode,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.statusCode,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.statusCode,
  });
}

class CancelFailure extends Failure {
  const CancelFailure({
    required super.message,
    super.statusCode,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode,
  });
}