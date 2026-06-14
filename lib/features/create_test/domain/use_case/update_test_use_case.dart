import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class UpdateTestUseCase {
  final CreateTestRepository repository;

  const UpdateTestUseCase(this.repository);

  Future<UpdateTestResponseEntity> call({
    required UpdateTestParams params,
  }) {
    debugPrint('============ UpdateTestUseCase.call ============');
    debugPrint('→ testId: ${params.testId}');
    debugPrint('→ title: ${params.title}');
    debugPrint('→ questions count: ${params.questions.length}');
    debugPrint('→ interestIds: ${params.interestIds}');
    debugPrint('================================================');

    return repository.updateTest(params: params);
  }
}