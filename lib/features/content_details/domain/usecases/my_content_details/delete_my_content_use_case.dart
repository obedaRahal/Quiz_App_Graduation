import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/delete_content_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/my_content_details_repository.dart';

class DeleteMyContentUseCase {
  final MyContentDetailsRepository repository;

  const DeleteMyContentUseCase(this.repository);

  Future<DeleteContentResponseEntity> call(int contentId) {
    return repository.deleteMyContent(contentId);
  }
}