import '../../domain/entities/other_content_report_response_entity.dart';
import 'other_content_report_data_model.dart';

class OtherContentReportResponseModel
    extends OtherContentReportResponseEntity {
  const OtherContentReportResponseModel({
    required super.success,
    required super.title,
    required super.data,
    required super.statusCode,
  });

  factory OtherContentReportResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OtherContentReportResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: OtherContentReportDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] ?? 0,
    );
  }
}