import '../entities/other_content_report_response_entity.dart';
import '../entities/report_other_content_params.dart';

abstract class OtherContentReportRepository {
  Future<OtherContentReportResponseEntity> reportContent(
    ReportOtherContentParams params,
  );
}