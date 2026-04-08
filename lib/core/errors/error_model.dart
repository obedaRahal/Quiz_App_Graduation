class ErrorModel {
  final int status;
  final String errorMessage;

  const ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(
    Map<String, dynamic> json, {
    int fallbackStatusCode = 0,
    String? fallbackMessage,
  }) {
    return ErrorModel(
      status: _extractStatus(json, fallbackStatusCode),
      errorMessage: _extractMessage(json, fallbackMessage),
    );
  }

  static int _extractStatus(Map<String, dynamic> json, int fallbackStatusCode) {
    return _parseStatus(json['status'] ?? json['statusCode'] ?? json['code']) ??
        fallbackStatusCode;
  }

  static String _extractMessage(
    Map<String, dynamic> json,
    String? fallbackMessage,
  ) {
    final value =
        json['errorMessage'] ??
        json['message'] ??
        json['error'] ??
        json['detail'];

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
