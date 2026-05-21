import '../../domain/entities/submit_report_entity.dart';

class SubmitReportModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;
  final bool isStatusChanged;

  const SubmitReportModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
    required this.isStatusChanged,
  });

  factory SubmitReportModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return SubmitReportModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
      isStatusChanged: data['is_status_changed'] as bool? ?? false,
    );
  }

  SubmitReportEntity toEntity() {
    return SubmitReportEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
      isStatusChanged: isStatusChanged,
    );
  }
}
