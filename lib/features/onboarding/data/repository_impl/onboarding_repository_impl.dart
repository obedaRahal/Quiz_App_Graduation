import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_discovery_source_response.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OnboardingDiscoverySourceResponse>>
  submitDiscoverySource({
    required String email,
    required String discoverySource,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitDiscoverySource ============",
    );
    debugPrint("→ params: {email: $email, discovery_source: $discoverySource}");

    try {
      debugPrint("→ calling remoteDataSource.submitDiscoverySource");

      final model = await remoteDataSource.submitDiscoverySource(
        email: email,
        discoverySource: discoverySource,
      );

      debugPrint("← remoteDataSource.submitDiscoverySource success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          message: e.errorModel.errorMessage,
          title: e.errorModel.errorTitle,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }
}
