import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/other_test_details_overview_entity.dart';
import '../../domain/repositories/details_of_test_repository.dart';
import '../data_sources/details_of_test_remote_data_source.dart';

class DetailsOfTestRepositoryImpl implements DetailsOfTestRepository {
  final DetailsOfTestRemoteDataSource remoteDataSource;

  const DetailsOfTestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
  getOtherTestDetailsOverview({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsOverview");

      final model = await remoteDataSource.getOtherTestDetailsOverview(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsOverview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OtherTestDetailsSampleEntity>>
  getOtherTestDetailsSample({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsSample");

      final model = await remoteDataSource.getOtherTestDetailsSample(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsSample success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsSample Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OtherTestDetailsReviewsEntity>>
  getOtherTestDetailsReviews({
    required int testId,
    required String rating,
  }) async {
    debugPrint(
      "============ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews ============",
    );
    debugPrint("→ params: {testId: $testId, rating: $rating}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherTestDetailsReviews");

      final model = await remoteDataSource.getOtherTestDetailsReviews(
        testId: testId,
        rating: rating,
      );

      debugPrint("← remoteDataSource.getOtherTestDetailsReviews success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsReviews Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }
}
