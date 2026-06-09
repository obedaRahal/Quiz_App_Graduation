import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class CreateManualTestUseCase {
  final CreateTestRepository repository;

  const CreateManualTestUseCase(this.repository);

  Future<CreateManualTestResponseEntity> call({
    required CreateManualTestParams params,
  }) {
    return repository.createManualTest(params: params);
  }
}