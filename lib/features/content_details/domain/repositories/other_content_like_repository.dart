import '../entities/other_content_like_response_entity.dart';

abstract class OtherContentLikeRepository {

  Future<OtherContentLikeResponseEntity> likeContent(
    int contentId,
  );

  Future<OtherContentLikeResponseEntity> unlikeContent(
    int contentId,
  );
}