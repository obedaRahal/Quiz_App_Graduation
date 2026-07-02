import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/follow_publisher_response_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/similar_content_response_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/unfollow_publisher_response_model.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';

import '../../domain/entities/other_content_details_params.dart';
import '../models/other_content_details_model.dart';

abstract class OtherContentDetailsRemoteDataSource {
  Future<OtherContentDetailsModel> getOtherContentDetails(
    OtherContentDetailsParams params,
  );
  Future<void> downloadContent(int contentId);
  Future<SimilarContentResponseModel> getSimilarContent(
    SimilarContentParams params,
  );
  Future<FollowPublisherResponseModel> followPublisher(int publisherId);
  Future<UnfollowPublisherResponseModel> unfollowPublisher(int publisherId);
}

class OtherContentDetailsRemoteDataSourceImpl
    implements OtherContentDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  const OtherContentDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OtherContentDetailsModel> getOtherContentDetails(
    OtherContentDetailsParams params,
  ) async {
    debugPrint(
      '================ OtherContentDetailsRemoteDataSource ================',
    );
    debugPrint('GET: ${EndPoints.otherContentDetails(params.contentId)}');

    final response = await apiConsumer.get(
      EndPoints.otherContentDetails(params.contentId),
    );

    debugPrint('Other content details response received successfully');

    return OtherContentDetailsModel.fromJson(response);
  }

  @override
  Future<void> downloadContent(int contentId) async {
    debugPrint(
      '================ DownloadContentRemoteDataSource ================',
    );

    debugPrint('GET: ${EndPoints.downloadContent(contentId)}');

    await apiConsumer.get(EndPoints.downloadContent(contentId));

    debugPrint('Download content request completed successfully');
  }

  @override
  Future<SimilarContentResponseModel> getSimilarContent(
    SimilarContentParams params,
  ) async {
    final interestQuery = params.interestIds
        .take(3)
        .map((id) => 'interest_ids[]=$id')
        .join('&');

    final cursorQuery = params.cursor != null && params.cursor!.isNotEmpty
        ? '&cursor=${Uri.encodeComponent(params.cursor!)}'
        : '';

    final url =
        '${EndPoints.similarContent(params.contentId)}?$interestQuery&per_page=${params.perPage}$cursorQuery';

    debugPrint(
      '================ SimilarContentRemoteDataSource ================',
    );
    debugPrint('GET: $url');
    debugPrint('content id: ${params.contentId}');
    debugPrint('interest ids: ${params.interestIds}');

    final response = await apiConsumer.get(url);

    debugPrint('Similar content response received successfully');

    return SimilarContentResponseModel.fromJson(response);
  }
  @override
Future<FollowPublisherResponseModel> followPublisher(int publisherId) async {
  debugPrint('================ FollowPublisherRemoteDataSource ================');
  debugPrint('POST: ${EndPoints.followPublisher(publisherId)}');

  final response = await apiConsumer.post(
    EndPoints.followPublisher(publisherId),
  );

  debugPrint('Follow publisher response received successfully');

  return FollowPublisherResponseModel.fromJson(response);
}
@override
Future<UnfollowPublisherResponseModel> unfollowPublisher(int publisherId) async {
  debugPrint('================ UnfollowPublisherRemoteDataSource ================');
  debugPrint('DELETE: ${EndPoints.unfollowPublisher(publisherId)}');

  final response = await apiConsumer.delete(
    EndPoints.unfollowPublisher(publisherId),
  );

  debugPrint('Unfollow publisher response received successfully');

  return UnfollowPublisherResponseModel.fromJson(response);
}
}
