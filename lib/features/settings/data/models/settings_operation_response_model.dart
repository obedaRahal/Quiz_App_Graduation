class SettingsOperationResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const SettingsOperationResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory SettingsOperationResponseModel.fromJson(Map<String, dynamic> json) {
    return SettingsOperationResponseModel(
      success: _parseBool(json['success']),
      title: _parseText(json['title']),
      message: _parseText(json['message']),
      statusCode: _parseInt(json['status_code']),
    );
  }
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1';
}

String _parseText(dynamic value) {
  final text = value?.toString().trim() ?? '';
  return text.toLowerCase() == 'null' ? '' : text;
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString().trim() ?? '') ?? 0;
}
