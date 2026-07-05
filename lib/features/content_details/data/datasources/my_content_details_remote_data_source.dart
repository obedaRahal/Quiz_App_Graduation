import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/content_details/data/models/my_content_details/delete_content_response_model.dart';
import 'package:quiz_app_grad/features/content_details/data/models/my_content_details/my_content_details_model.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_params.dart';

abstract class MyContentDetailsRemoteDataSource {
  Future<MyContentDetailsModel> getMyPublicContentDetails(
    MyContentDetailsParams params,
  );
  Future<DeleteContentResponseModel> deleteMyContent(int contentId);
}

class MyContentDetailsRemoteDataSourceImpl
    implements MyContentDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  const MyContentDetailsRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<MyContentDetailsModel> getMyPublicContentDetails(
    MyContentDetailsParams params,
  ) async {
    debugPrint('================ MyContentDetailsRemoteDataSource ================');
    debugPrint('GET: ${EndPoints.myPublicContentDetails(params.contentId)}');

    final response = await apiConsumer.get(
      EndPoints.myPublicContentDetails(params.contentId),
    );

    debugPrint('My public content details response received successfully');

    return MyContentDetailsModel.fromJson(response);
  }
  @override
Future<DeleteContentResponseModel> deleteMyContent(int contentId) async {
  debugPrint('================ DeleteContentRemoteDataSource ================');
  debugPrint('DELETE: ${EndPoints.deleteMyContent(contentId)}');

  final response = await apiConsumer.delete(
    EndPoints.deleteMyContent(contentId),
  );

  debugPrint('Delete content response received successfully');

  return DeleteContentResponseModel.fromJson(response);
}
}