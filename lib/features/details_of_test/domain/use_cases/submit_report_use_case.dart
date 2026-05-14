import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/submit_report_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/submit_report_params.dart';

class SubmitReportUseCase {
  final DetailsOfTestRepository repository;

  const SubmitReportUseCase(this.repository);

  Future<Either<Failure, SubmitReportEntity>> call(SubmitReportParams params) {
    debugPrint("============ SubmitReportUseCase.call ============");
    debugPrint(
      "→ params: {targetType: ${params.targetType.name}, targetId: ${params.targetId}, reason: ${params.reason}, descriptionLength: ${params.description.trim().length}}",
    );

    return repository.submitReport(
      targetType: params.targetType,
      targetId: params.targetId,
      reason: params.reason,
      description: params.description,
    );
  }
}
