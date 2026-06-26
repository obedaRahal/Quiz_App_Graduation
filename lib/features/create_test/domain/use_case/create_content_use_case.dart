import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class CreateContentUseCase {
  final CreateTestRepository repository;

  const CreateContentUseCase(this.repository);

  Future<CreateContentResponseEntity> call({
    required CreateContentParams params,
  }) {
    return repository.createContent(params: params);
  }
}