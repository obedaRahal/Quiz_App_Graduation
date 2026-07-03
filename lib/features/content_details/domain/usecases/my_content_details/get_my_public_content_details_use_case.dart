import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/my_content_details_repository.dart';

class GetMyPublicContentDetailsUseCase {
  final MyContentDetailsRepository repository;

  const GetMyPublicContentDetailsUseCase(this.repository);

  Future<MyContentDetailsEntity> call(MyContentDetailsParams params) {
    return repository.getMyPublicContentDetails(params);
  }
}