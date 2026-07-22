import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/search/data/models/search_user_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchUsersResponseModel> searchUsers({
    required String query,
    String? cursor,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiConsumer apiConsumer;

  const SearchRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<SearchUsersResponseModel> searchUsers({
    required String query,
    String? cursor,
  }) async {
    debugPrint(
      '============ SearchRemoteDataSourceImpl.searchUsers ============',
    );

    final endpoint = EndPoints.searchUsers(query: query, cursor: cursor);

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: GET');
    debugPrint('→ query: $query');
    debugPrint('→ cursor: $cursor');

    final response = await apiConsumer.get(endpoint);

    debugPrint('← response: $response');
    debugPrint(
      '================================================================',
    );

    return SearchUsersResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }
}
