import '../../domain/entities/other_content_report_response_entity.dart';
import '../../domain/entities/report_other_content_params.dart';
import '../../domain/repositories/other_content_report_repository.dart';
import '../datasources/other_content_report_remote_data_source.dart';

class OtherContentReportRepositoryImpl
    implements OtherContentReportRepository {
  final OtherContentReportRemoteDataSource remoteDataSource;

  const OtherContentReportRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<OtherContentReportResponseEntity> reportContent(
    ReportOtherContentParams params,
  ) {
    return remoteDataSource.reportContent(params);
  }
}