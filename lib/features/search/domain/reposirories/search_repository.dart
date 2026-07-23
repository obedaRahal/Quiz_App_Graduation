import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_history_entity.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchUsersResponseEntity>> searchUsers({
    required String query,
    String? cursor,
  });

  Future<Either<Failure, List<SearchHistoryEntity>>> getSearchHistory();

  Future<Either<Failure, void>> deleteSearchHistoryItem({
    required int historyId,
  });

  Future<Either<Failure, void>> clearSearchHistory();
}
