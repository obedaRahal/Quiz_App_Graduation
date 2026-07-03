import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/similar_content_response_model.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/follow_publisher_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/unfollow_publisher_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart';

import '../../domain/entities/other_content_details_entity.dart';
import '../../domain/entities/other_content_details_params.dart';
import '../datasources/other_content_details_remote_data_source.dart';

class OtherContentDetailsRepositoryImpl
    implements OtherContentDetailsRepository {
  final OtherContentDetailsRemoteDataSource remoteDataSource;

  const OtherContentDetailsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<OtherContentDetailsEntity> getOtherContentDetails(
    OtherContentDetailsParams params,
  ) async {
    debugPrint('================ OtherContentDetailsRepositoryImpl ================');
    debugPrint('contentId: ${params.contentId}');

    return remoteDataSource.getOtherContentDetails(params);
  }
 @override
Future<String> downloadContent(int contentId) {
  return remoteDataSource.downloadContent(contentId);
}
@override
Future<SimilarContentResponseEntity> getSimilarContent(
  SimilarContentParams params,
) {
  return remoteDataSource.getSimilarContent(params);
}
@override
Future<FollowPublisherResponseEntity> followPublisher(int publisherId) {
  return remoteDataSource.followPublisher(publisherId);
}
@override
Future<UnfollowPublisherResponseEntity> unfollowPublisher(int publisherId) {
  return remoteDataSource.unfollowPublisher(publisherId);
}
}