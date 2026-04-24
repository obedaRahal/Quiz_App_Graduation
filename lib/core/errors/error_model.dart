class ErrorModel {
  final int status;
  final String errorMessage;
  final String errorTitle;
  final Map<String, dynamic> meta;
  const ErrorModel({
    required this.status,
    required this.errorMessage,
    required this.errorTitle,
    this.meta = const {},
  });

  factory ErrorModel.fromJson(
    Map<String, dynamic> json, {
    int fallbackStatusCode = 0,
    String? fallbackMessage,
  }) {
    return ErrorModel(
      status: _extractStatus(json, fallbackStatusCode),
      errorMessage: _extractMessage(json, fallbackMessage),
      errorTitle: _extractTitle(json),
      meta: json['meta'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['meta'])
          : const {},
    );
  }
  String? get reason {
    final value = meta['reason'];
    if (value == null) return null;
    return value.toString();
  }

  bool get isPermanent {
    return meta['is_permanent'] == true;
  }

  String? get startsAt {
    final value = meta['starts_at'];
    if (value == null) return null;
    return value.toString();
  }

  String? get endsAt {
    final value = meta['ends_at'];
    if (value == null) return null;
    return value.toString();
  }

  int? get lastCompletedStep {
    final value = meta['last_completed_step'];

    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  @override
  String toString() => errorMessage;
  static int _extractStatus(Map<String, dynamic> json, int fallbackStatusCode) {
    return _parseStatus(json['status'] ?? json['statusCode'] ?? json['code']) ??
        fallbackStatusCode;
  }

  static String _extractTitle(Map<String, dynamic> json) {
    final value = json['title'] ?? json['errorTitle'] ?? json['error'];

    final title = value?.toString().trim();

    if (title != null && title.isNotEmpty) {
      return title;
    }

    return 'حدث خطأ';
  }

  static String _extractMessage(
    Map<String, dynamic> json,
    String? fallbackMessage,
  ) {
    final value =
        json['errorMessage'] ??
        json['message'] ??
        json['detail'] ??
        json['error'];

    final message = value?.toString().trim();

    if (message != null && message.isNotEmpty) {
      return message;
    }

    return fallbackMessage?.trim().isNotEmpty == true
        ? fallbackMessage!.trim()
        : 'Unexpected error occurred';
  }

  static int? _parseStatus(dynamic value) {
    if (value is int) return value;
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
