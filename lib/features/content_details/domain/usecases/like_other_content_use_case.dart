import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_like_repository.dart';

import '../entities/other_content_like_response_entity.dart';

class LikeOtherContentUseCase {

  final OtherContentLikeRepository repository;

  LikeOtherContentUseCase(this.repository);

  Future<OtherContentLikeResponseEntity> call(
    int contentId,
  ){

    return repository.likeContent(contentId);

  }

}