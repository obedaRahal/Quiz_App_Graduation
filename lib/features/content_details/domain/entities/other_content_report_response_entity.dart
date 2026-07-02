import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_report_entity.dart';

class OtherContentReportResponseEntity {
  final bool success;
  final String title;
  final OtherContentReportDataEntity data;
  final int statusCode;

  const OtherContentReportResponseEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}