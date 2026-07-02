import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/report_other_content_params.dart';
import 'package:uuid/uuid.dart';

import '../models/other_content_report_response_model.dart';

abstract class OtherContentReportRemoteDataSource {
  Future<OtherContentReportResponseModel> reportContent(
    ReportOtherContentParams params,
  );
}

class OtherContentReportRemoteDataSourceImpl
    implements OtherContentReportRemoteDataSource {
  final ApiConsumer apiConsumer;

  const OtherContentReportRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<OtherContentReportResponseModel> reportContent(
    ReportOtherContentParams params,
  ) async {
    final idempotencyKey = const Uuid().v4();

    final body = <String, dynamic>{
  'reason': params.reason,
  'description': (params.description?.trim().isNotEmpty ?? false)
    ? params.description!.trim()
    : 'لم يتم إضافة وصف',
};

    debugPrint('================ ReportContentRemoteDataSource ================');
    debugPrint('POST: ${EndPoints.reportContent(params.contentId)}');
    debugPrint('Body: $body');
    debugPrint('Idempotency-Key: $idempotencyKey');

    final response = await apiConsumer.post(
      EndPoints.reportContent(params.contentId),
      data: body,
      headers: {
        'Idempotency-Key': idempotencyKey,
      },
    );

    return OtherContentReportResponseModel.fromJson(response);
  }
}