import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/other_test_details_overview_entity.dart';
import '../../domain/repositories/details_of_test_repository.dart';
import '../data_sources/details_of_test_remote_data_source.dart';

class DetailsOfTestRepositoryImpl implements DetailsOfTestRepository {
  final DetailsOfTestRemoteDataSource remoteDataSource;

  const DetailsOfTestRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
      getOtherTestDetailsOverview({
    required int testId,
  }) async {
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

      return Left(
        CacheFailure(
          title: 'خطأ محلي',
          message: e.errorMessage,
        ),
      );
    } catch (e) {
      debugPrint(
        "✗ DetailsOfTestRepositoryImpl.getOtherTestDetailsOverview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع',
        ),
      );
    }
  }
}