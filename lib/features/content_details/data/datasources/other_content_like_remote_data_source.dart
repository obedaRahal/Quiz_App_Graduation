import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';

import '../models/other_content_like_response_model.dart';

abstract class OtherContentLikeRemoteDataSource {

  Future<OtherContentLikeResponseModel> likeContent(
    int contentId,
  );

  Future<OtherContentLikeResponseModel> unlikeContent(
    int contentId,
  );

}

class OtherContentLikeRemoteDataSourceImpl
    implements OtherContentLikeRemoteDataSource {

  final ApiConsumer apiConsumer;

  OtherContentLikeRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<OtherContentLikeResponseModel> likeContent(
    int contentId,
  ) async {

    debugPrint(
      '================ LikeContentRemoteDataSource ================',
    );

    debugPrint(
      'POST: ${EndPoints.likeContent}/$contentId',
    );

    final response = await apiConsumer.post(
      '${EndPoints.likeContent}/$contentId',
    );

    debugPrint(
      'Like response received successfully',
    );

    return OtherContentLikeResponseModel.fromJson(response);

  }

  @override
  Future<OtherContentLikeResponseModel> unlikeContent(
    int contentId,
  ) async {

    debugPrint(
      '================ UnlikeContentRemoteDataSource ================',
    );

    debugPrint(
      'DELETE: ${EndPoints.unlikeContent}/$contentId',
    );

    final response = await apiConsumer.delete(
      '${EndPoints.unlikeContent}/$contentId',
    );

    debugPrint(
      'Unlike response received successfully',
    );

    return OtherContentLikeResponseModel.fromJson(response);

  }

}