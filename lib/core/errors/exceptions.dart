import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'error_model.dart';

abstract class ServerException implements Exception {
  final ErrorModel errorModel;

  const ServerException(this.errorModel);

  @override
  String toString() => errorModel.errorMessage;
}

class CacheException implements Exception {
  final String errorMessage;

  const CacheException({required this.errorMessage});

  @override
  String toString() => errorMessage;
}

// =========================
// Server / Network Exceptions
// =========================

class BadCertificateException extends ServerException {
  const BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  const ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  const BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  const ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  const ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  const SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  const ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  const NotFoundException(super.errorModel);
}

class ConflictException extends ServerException {
  const ConflictException(super.errorModel);
}

class ValidationException extends ServerException {
  const ValidationException(super.errorModel);
}

class TooManyRequestsException extends ServerException {
  const TooManyRequestsException(super.errorModel);
}

class InternalServerException extends ServerException {
  const InternalServerException(super.errorModel);
}

class ServiceUnavailableException extends ServerException {
  const ServiceUnavailableException(super.errorModel);
}

class CancelException extends ServerException {
  const CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  const UnknownException(super.errorModel);
}

ErrorModel _buildErrorModel(DioException e) {
  final statusCode = e.response?.statusCode ?? 0;
  final data = e.response?.data;

  if (data is Map<String, dynamic>) {
    return ErrorModel.fromJson(
      data,
      fallbackStatusCode: statusCode,
      fallbackMessage: e.message,
    );
  }

  return ErrorModel(
    status: statusCode,
    errorMessage: data?.toString() ?? e.message ?? 'Unexpected error occurred',
    errorTitle: data?.toString() ?? e.message ?? 'Unexpected error occurred',
    meta: const {},
  );
}

/// ترمي Exception دايمًا، ولا تُرجع قيمة.
Never handleDioException(DioException e) {
  debugPrint('================ DIO EXCEPTION ================');
  debugPrint('DioException type: ${e.type}');
  debugPrint('DioException status code: ${e.response?.statusCode}');
  debugPrint('DioException response data: ${e.response?.data}');
  debugPrint('DioException message: ${e.message}');

  final errorModel = _buildErrorModel(e);

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(errorModel);

    case DioExceptionType.badCertificate:
      throw BadCertificateException(errorModel);

    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(errorModel);

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(errorModel);

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(errorModel);

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;

      switch (statusCode) {
        case 400:
          throw BadResponseException(errorModel);
        case 401:
          throw UnauthorizedException(errorModel);
        case 403:
          throw ForbiddenException(errorModel);
        case 404:
          throw NotFoundException(errorModel);
        case 409:
          throw ConflictException(errorModel);
        case 422:
          throw ValidationException(errorModel);
        case 429:
          throw TooManyRequestsException(errorModel);
        case 500:
          throw InternalServerException(errorModel);
        case 502:
        case 503:
        case 504:
          throw ServiceUnavailableException(errorModel);
        default:
          throw BadResponseException(errorModel);
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(
          status: 0,
          errorMessage: e.message ?? 'Request was cancelled',
          errorTitle: e.message ?? 'Request was cancelled',
        ),
      );

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(
          status: 0,
          errorMessage: e.message ?? 'Unknown error occurred',
          errorTitle: e.message ?? 'Unknown error occurred',
        ),
      );
  }
  
}