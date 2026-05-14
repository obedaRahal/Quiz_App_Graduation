import '../../domain/entities/submit_report_entity.dart';

class SubmitReportModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const SubmitReportModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory SubmitReportModel.fromJson(Map<String, dynamic> json) {
    return SubmitReportModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  SubmitReportEntity toEntity() {
    return SubmitReportEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}