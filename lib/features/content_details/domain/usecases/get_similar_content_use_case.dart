import '../entities/similar_content_params.dart';
import '../entities/similar_content_response_entity.dart';
import '../repositories/other_content_details_repository.dart';

class GetSimilarContentUseCase {
  final OtherContentDetailsRepository repository;

  const GetSimilarContentUseCase(this.repository);

  Future<SimilarContentResponseEntity> call(
    SimilarContentParams params,
  ) {
    return repository.getSimilarContent(params);
  }
}