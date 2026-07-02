import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';

import '../models/other_content_bookmark_response_model.dart';

abstract class OtherContentBookmarkRemoteDataSource {
  Future<OtherContentBookmarkResponseModel> bookmarkContent(int contentId);

  Future<OtherContentBookmarkResponseModel> unbookmarkContent(int contentId);
}

class OtherContentBookmarkRemoteDataSourceImpl
    implements OtherContentBookmarkRemoteDataSource {
  final ApiConsumer apiConsumer;

  const OtherContentBookmarkRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<OtherContentBookmarkResponseModel> bookmarkContent(
    int contentId,
  ) async {
    debugPrint('================ BookmarkContentRemoteDataSource ================');
    debugPrint('POST: ${EndPoints.bookmarkContent(contentId)}');

    final response = await apiConsumer.post(
      EndPoints.bookmarkContent(contentId),
    );

    debugPrint('Bookmark content response received successfully');

    return OtherContentBookmarkResponseModel.fromJson(response);
  }

  @override
  Future<OtherContentBookmarkResponseModel> unbookmarkContent(
    int contentId,
  ) async {
    debugPrint('================ UnbookmarkContentRemoteDataSource ================');
    debugPrint('DELETE: ${EndPoints.unbookmarkContent(contentId)}');

    final response = await apiConsumer.delete(
      EndPoints.unbookmarkContent(contentId),
    );

    debugPrint('Unbookmark content response received successfully');

    return OtherContentBookmarkResponseModel.fromJson(response);
  }
}