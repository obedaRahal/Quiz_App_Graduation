import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/search/data/remote_data_source/search_remote_data_source.dart';
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
}
