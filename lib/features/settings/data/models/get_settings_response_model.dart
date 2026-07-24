import 'package:quiz_app_grad/features/settings/data/models/settings_model.dart';

class GetSettingsResponseModel {
  final bool success;
  final String title;
  final SettingsModel data;
  final int statusCode;

  const GetSettingsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory GetSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return GetSettingsResponseModel(
      success: _parseSuccess(json['success']),
      title: json['title']?.toString().trim() ?? '',
      data: SettingsModel.fromJson(
        rawData is Map<String, dynamic> ? rawData : <String, dynamic>{},
      ),
      statusCode: _parseStatusCode(json['status_code']),
    );
  }

  static int _parseStatusCode(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _parseSuccess(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}
