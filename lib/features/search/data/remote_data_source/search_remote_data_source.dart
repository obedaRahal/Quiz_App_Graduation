import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/search/data/models/search_history_model.dart';
import 'package:quiz_app_grad/features/search/data/models/search_user_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchUsersResponseModel> searchUsers({
    required String query,
    String? cursor,
  });

  Future<List<SearchHistoryModel>> getSearchHistory();

  Future<void> deleteSearchHistoryItem({required int historyId});

  Future<void> clearSearchHistory();
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

  @override
  Future<List<SearchHistoryModel>> getSearchHistory() async {
    debugPrint(
      '============ SearchRemoteDataSource.getSearchHistory ============',
    );

    final response = await apiConsumer.get(EndPoints.searchHistory);

    final responseModel = SearchHistoryResponseModel.fromJson(response);

    debugPrint('✓ history fetched');
    debugPrint('→ count: ${responseModel.histories.length}');
    debugPrint(
      '===============================================================',
    );

    return responseModel.histories;
  }

  @override
  Future<void> deleteSearchHistoryItem({required int historyId}) async {
    debugPrint(
      '============ SearchRemoteDataSource.deleteSearchHistoryItem ============',
    );
    debugPrint('→ historyId: $historyId');

    await apiConsumer.delete(
      EndPoints.deleteSearchHistoryItem(historyId: historyId),
    );

    debugPrint('✓ history item deleted');
    debugPrint(
      '======================================================================',
    );
  }

  @override
  Future<void> clearSearchHistory() async {
    debugPrint(
      '============ SearchRemoteDataSource.clearSearchHistory ============',
    );

    await apiConsumer.delete(EndPoints.searchHistory);

    debugPrint('✓ search history cleared');
    debugPrint(
      '================================================================',
    );
  }
}
