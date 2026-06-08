import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/data/data_sources/my_public_test_details_remote_data_source.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/delete_my_test_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_private_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_test_modifications_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';

class MyPublicTestDetailsRepositoryImpl
    implements MyPublicTestDetailsRepository {
  final MyPublicTestDetailsRemoteDataSource remoteDataSource;

  const MyPublicTestDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyPublicTestDetailsOverviewEntity>>
  getMyPublicTestDetailsOverview({required int testId}) async {
    debugPrint(
      "============ MyPublicTestDetailsRepositoryImpl.getMyPublicTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getMyPublicTestDetailsOverview");

      final model = await remoteDataSource.getMyPublicTestDetailsOverview(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getMyPublicTestDetailsOverview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestDetailsOverview ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestDetailsOverview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestDetailsOverview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب تفاصيل الاختبار',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MyPublicTestStatusHistoryEntity>>
  getMyPublicTestStatusHistory({required int testId}) async {
    debugPrint(
      "============ MyPublicTestDetailsRepositoryImpl.getMyPublicTestStatusHistory ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.getMyPublicTestStatusHistory");

      final model = await remoteDataSource.getMyPublicTestStatusHistory(
        testId: testId,
      );

      debugPrint("← remoteDataSource.getMyPublicTestStatusHistory success");
      debugPrint("→ history count: ${model.data.length}");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestStatusHistory ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestStatusHistory CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestStatusHistory Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب سجل الحالات',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MyPublicTestReviewsEntity>> getMyPublicTestReviews({
    required int testId,
    required String rating,
    required int page,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRepositoryImpl.getMyPublicTestReviews ============",
    );
    debugPrint("→ params: {testId: $testId, rating: $rating");

    try {
      debugPrint("→ calling remoteDataSource.getMyPublicTestReviews");

      final model = await remoteDataSource.getMyPublicTestReviews(
        testId: testId,
        rating: rating,
        page: page,
      );

      debugPrint("← remoteDataSource.getMyPublicTestReviews success");
      debugPrint("→ reviews count: ${model.data.reviews.length}");
      debugPrint("→ current page: ${model.data.meta.currentPage}");
      debugPrint("→ hasMorePages: ${model.data.meta.hasMorePages}");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestReviews ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestReviews CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyPublicTestReviews Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب تقييمات الاختبار',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MyTestModificationsEntity>> getMyTestModifications({
    required int testId,
    required int roundId,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRepositoryImpl.getMyTestModifications ============",
    );
    debugPrint("→ params: {testId: $testId, roundId: $roundId}");

    try {
      debugPrint("→ calling remoteDataSource.getMyTestModifications");

      final model = await remoteDataSource.getMyTestModifications(
        testId: testId,
        roundId: roundId,
      );

      debugPrint("← remoteDataSource.getMyTestModifications success");
      debugPrint("→ modifications count: ${model.data.length}");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyTestModifications ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyPublicTestDetailsRepositoryImpl.getMyTestModifications CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.getMyTestModifications Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب التعديلات المطلوبة',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MyPrivateTestDetailsOverviewEntity>>
  getMyPrivateTestDetailsOverview({required int testId}) async {
    debugPrint(
      "============ MyPrivateTestDetailsRepositoryImpl.getMyPrivateTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      final model = await remoteDataSource.getMyPrivateTestDetailsOverview(
        testId: testId,
      );

      debugPrint("→ converting model to entity, title: ${model.title}");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint("✗ ServerException: ${e.errorModel.errorMessage}");
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint("✗ Unexpected error: $e");
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب بيانات الاختبار الخاص',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DeleteMyTestEntity>> deleteMyTest({
    required int testId,
  }) async {
    debugPrint(
      "============ MyPublicTestDetailsRepositoryImpl.deleteMyTest ============",
    );
    debugPrint("→ params: {testId: $testId}");

    try {
      debugPrint("→ calling remoteDataSource.deleteMyTest");

      final model = await remoteDataSource.deleteMyTest(testId: testId);

      debugPrint("← remoteDataSource.deleteMyTest success");
      debugPrint("→ title: ${model.title}");
      debugPrint("→ message: ${model.message}");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.deleteMyTest ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyPublicTestDetailsRepositoryImpl.deleteMyTest CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyPublicTestDetailsRepositoryImpl.deleteMyTest Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء حذف الاختبار',
        ),
      );
    }
  }
}
