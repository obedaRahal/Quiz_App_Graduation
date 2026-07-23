import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/data/remote_data_source/search_remote_data_source.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_history_entity.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';
import 'package:quiz_app_grad/features/search/domain/reposirories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  const SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchUsersResponseEntity>> searchUsers({
    required String query,
    String? cursor,
  }) async {
    debugPrint('============ SearchRepositoryImpl.searchUsers ============');
    debugPrint('→ query: $query');
    debugPrint('→ cursor: $cursor');

    try {
      final response = await remoteDataSource.searchUsers(
        query: query,
        cursor: cursor,
      );

      debugPrint('✓ searchUsers success');
      debugPrint('→ users count: ${response.users.length}');
      debugPrint('→ perPage: ${response.meta.perPage}');
      debugPrint('→ nextCursor: ${response.meta.nextCursor}');
      debugPrint('→ previousCursor: ${response.meta.previousCursor}');
      debugPrint('→ hasMorePages: ${response.meta.hasMorePages}');
      debugPrint('==========================================================');

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('✗ searchUsers ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint('==========================================================');

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ searchUsers CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint('==========================================================');

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ searchUsers Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint('==========================================================');

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب نتائج البحث'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SearchHistoryEntity>>> getSearchHistory() async {
    debugPrint(
      '============ SearchRepositoryImpl.getSearchHistory ============',
    );

    try {
      final histories = await remoteDataSource.getSearchHistory();

      debugPrint('✓ getSearchHistory success');
      debugPrint('→ histories count: ${histories.length}');
      debugPrint(
        '===============================================================',
      );

      return Right(histories);
    } on ServerException catch (e) {
      debugPrint('✗ getSearchHistory ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '===============================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ getSearchHistory CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '===============================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ getSearchHistory Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '===============================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب سجل البحث'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistoryItem({
    required int historyId,
  }) async {
    debugPrint(
      '============ SearchRepositoryImpl.deleteSearchHistoryItem ============',
    );
    debugPrint('→ historyId: $historyId');

    try {
      await remoteDataSource.deleteSearchHistoryItem(historyId: historyId);

      debugPrint('✓ deleteSearchHistoryItem success');
      debugPrint(
        '=====================================================================',
      );

      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('✗ deleteSearchHistoryItem ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '=====================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ deleteSearchHistoryItem CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '=====================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ deleteSearchHistoryItem Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '=====================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف عنصر سجل البحث'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    debugPrint(
      '============ SearchRepositoryImpl.clearSearchHistory ============',
    );

    try {
      await remoteDataSource.clearSearchHistory();

      debugPrint('✓ clearSearchHistory success');
      debugPrint(
        '================================================================',
      );

      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('✗ clearSearchHistory ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ clearSearchHistory CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ clearSearchHistory Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف سجل البحث'),
      );
    }
  }
}
