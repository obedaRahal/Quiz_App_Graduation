import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Adds idempotency keys only to the mobile API routes that explicitly
/// require them. Keys are kept in memory for ten minutes, which lets a
/// repeated touch or a retry of the same request reuse the original key.
class IdempotencyInterceptor extends Interceptor {
  static const _headerName = 'Idempotency-Key';
  static const _entryLifetime = Duration(minutes: 10);

  final Uuid _uuid;
  final Map<String, _IdempotencyEntry> _entries = {};

  IdempotencyInterceptor({Uuid uuid = const Uuid()}) : _uuid = uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _removeExpiredEntries();

    if (!_requiresIdempotency(options) || options.headers.containsKey(_headerName)) {
      handler.next(options);
      return;
    }

    final fingerprint = _fingerprintFor(options);
    final entry = _entries.putIfAbsent(
      fingerprint,
      () => _IdempotencyEntry(
        key: _uuid.v4(),
        expiresAt: DateTime.now().add(_entryLifetime),
      ),
    );

    options.headers[_headerName] = entry.key;

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _removeExpiredEntries();
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _removeExpiredEntries();
    handler.next(error);
  }

  bool _requiresIdempotency(RequestOptions options) {
    final method = options.method.toUpperCase();
    final path = options.uri.path;

    return _idempotencyRoutes.any(
      (route) => route.method == method && route.path.hasMatch(path),
    );
  }

  String _fingerprintFor(RequestOptions options) {
    final method = options.method.toUpperCase();
    final path = options.uri.path;
    final query = _canonicalize(options.uri.queryParameters);
    final body = _canonicalize(options.data);

    return '$method|$path|$query|$body';
  }

  String _canonicalize(Object? value) {
    if (value == null) return 'null';

    if (value is FormData) {
      final fields = value.fields
          .map((field) => '${field.key}:${field.value}')
          .toList()
        ..sort();
      final files = value.files
          .map(
            (file) =>
                '${file.key}:${file.value.filename ?? ''}:${file.value.length}',
          )
          .toList()
        ..sort();

      return 'form(fields:${fields.join(',')};files:${files.join(',')})';
    }

    if (value is Map) {
      final entries = value.entries
          .map((entry) => MapEntry(entry.key.toString(), entry.value))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      return '{${entries.map((entry) => '${entry.key}:${_canonicalize(entry.value)}').join(',')}}';
    }

    if (value is Iterable) {
      return '[${value.map(_canonicalize).join(',')}]';
    }

    return value.toString();
  }

  void _removeExpiredEntries() {
    final now = DateTime.now();
    _entries.removeWhere((_, entry) => !entry.expiresAt.isAfter(now));
  }
}

class _IdempotencyEntry {
  final String key;
  final DateTime expiresAt;

  const _IdempotencyEntry({required this.key, required this.expiresAt});
}

class _IdempotencyRoute {
  final String method;
  final RegExp path;

  const _IdempotencyRoute(this.method, this.path);
}

final _idempotencyRoutes = <_IdempotencyRoute>[
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?home/users/search-history(?:/[^/]+)?$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?lab/create-test$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?lab/ai-question-generations$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?test/reports/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?test/reports/review/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?test/payments/stripe/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?test/delete/test/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?test/update/test/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?users-profile/follow/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?users-profile/unfollow/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?users-profile/folder-bookmarks/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?users-profile/folder-bookmarks/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?library/create-content$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?library/reports/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?library/delete/material/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?library/update/material/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?my-profile/update/basic-info/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?my-profile/update/academic-info/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?my-profile/update/scientific-interests/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?my-profile/update/photo/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?my-profile/delete/photo/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?folder/create$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?folder/update/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?folder/delete/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/create$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/create/study-subjects$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/delete/study-subjects/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/update/study-plan/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/delete/study-plan/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/create/task/[^/]+$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/update/task/[^/]+/[^/]+$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/delete/task/[^/]+/[^/]+$')),
  _IdempotencyRoute('PATCH', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/study-plans/[^/]+/tasks/[^/]+/subtasks/[^/]+/(?:complete|un-complete)$')),
  _IdempotencyRoute('PATCH', RegExp(r'^/(?:api/v1/user-mobile/)?study-plans/study-plans/[^/]+/tasks/[^/]+/(?:start|complete|un-complete)$')),
  _IdempotencyRoute('PATCH', RegExp(r'^/(?:api/v1/user-mobile/)?settings/task-reminders/(?:enable|disable)$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?settings/(?:date-time|theme-mode|create/certificate-request|certificate-visibility)$')),
  _IdempotencyRoute('DELETE', RegExp(r'^/(?:api/v1/user-mobile/)?settings/cancel/certificate-request$')),
  _IdempotencyRoute('POST', RegExp(r'^/(?:api/v1/user-mobile/)?notification/notifications/read$')),
];
