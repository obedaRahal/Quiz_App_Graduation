import 'package:quiz_app_grad/features/content_details/domain/entities/follow_publisher_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/unfollow_publisher_response_entity.dart';

import '../entities/other_content_details_entity.dart';
import '../entities/other_content_details_params.dart';

abstract class OtherContentDetailsRepository {
  Future<OtherContentDetailsEntity> getOtherContentDetails(
    OtherContentDetailsParams params,
  );
  Future<void> downloadContent(int contentId);
  Future<SimilarContentResponseEntity> getSimilarContent(
  SimilarContentParams params,
);
Future<FollowPublisherResponseEntity> followPublisher(int publisherId);
Future<UnfollowPublisherResponseEntity> unfollowPublisher(int publisherId);
}