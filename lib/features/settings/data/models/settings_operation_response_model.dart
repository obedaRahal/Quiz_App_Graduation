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
      success: json['success'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }
}
