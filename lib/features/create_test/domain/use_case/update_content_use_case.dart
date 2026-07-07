import '../entities/update_content_params.dart';
import '../entities/update_content_response_entity.dart';
import '../repositories/create_test_repository.dart';

class UpdateContentUseCase {
  final CreateTestRepository repository;

  const UpdateContentUseCase(this.repository);

  Future<UpdateContentResponseEntity> call(UpdateContentParams params) {
    return repository.updateContent(params);
  }
}