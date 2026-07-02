import '../entities/other_content_report_response_entity.dart';
import '../entities/report_other_content_params.dart';
import '../repositories/other_content_report_repository.dart';

class ReportOtherContentUseCase {
  final OtherContentReportRepository repository;

  const ReportOtherContentUseCase(this.repository);

  Future<OtherContentReportResponseEntity> call(
    ReportOtherContentParams params,
  ) {
    return repository.reportContent(params);
  }
}