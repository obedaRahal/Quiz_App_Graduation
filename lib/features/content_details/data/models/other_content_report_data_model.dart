import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_report_entity.dart';

class OtherContentReportDataModel extends OtherContentReportDataEntity {
  const OtherContentReportDataModel({
    required super.statusChangedToReported,
  });

  factory OtherContentReportDataModel.fromJson(Map<String, dynamic> json) {
    return OtherContentReportDataModel(
      statusChangedToReported: json['statusChangedToReported'] ?? false,
    );
  }
}