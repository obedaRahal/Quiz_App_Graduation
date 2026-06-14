import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/editable_test_questions_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/params/get_editable_test_questions_params.dart';

class GetEditableTestQuestionsUseCase {
  final CreateTestRepository repository;

  const GetEditableTestQuestionsUseCase(this.repository);

  Future<EditableTestQuestionsResponseEntity> call(
    GetEditableTestQuestionsParams params,
  ) {
    debugPrint('============ GetEditableTestQuestionsUseCase.call ============');
    debugPrint('→ params: {testId: ${params.testId}}');

    return repository.getEditableTestQuestions(testId: params.testId);
  }
}