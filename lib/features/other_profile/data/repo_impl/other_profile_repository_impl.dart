// lib/features/other_profile/data/repo_impl/other_profile_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart'; // تأكد من مسار الـ Exceptions الفعلي في مشروعك
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import '../../domain/entities/other_profile_overview_entity.dart';
import '../data_source/other_profile_remote_data_source.dart';

class OtherProfileRepositoryImpl implements OtherProfileRepository {
  final OtherProfileRemoteDataSource remoteDataSource;

  const OtherProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OtherProfileOverviewEntity>> getOtherProfileOverview({
    required int userId,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileOverview ============",
    );
    debugPrint("→ params: {userId: $userId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileOverview");

      final model = await remoteDataSource.getOtherProfileOverview(
        userId: userId,
      );

      debugPrint("← remoteDataSource.getOtherProfileOverview success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileOverview ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileOverview CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileOverview Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message:
              'حدث خطأ غير متوقع أثناء جلب نظرة عامة عن الملف الشخصي الآخر',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileTestsResponseEntity>>
  getOtherProfileTests({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileTests ============",
    );
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileTests");

      final model = await remoteDataSource.getOtherProfileTests(
        userId: userId,
        tab: tab,
        cursor: cursor,
      );

      debugPrint("← remoteDataSource.getOtherProfileTests success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileTests ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileTests CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileTests Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب اختبارات الملف الشخصي الآخر',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileFoldersResponseEntity>>
  getOtherProfileFolders({required int userId, String? cursor}) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileFolders ============",
    );
    debugPrint("→ params: {userId: $userId, cursor: $cursor}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileFolders");

      final model = await remoteDataSource.getOtherProfileFolders(
        userId: userId,
        cursor: cursor,
      );

      debugPrint("← remoteDataSource.getOtherProfileFolders success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileFolders ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileFolders CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileFolders Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب قوائم الملف الشخصي الآخر',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileContentResponseEntity>>
  getOtherProfileContent({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileContent ============",
    );
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileContent");

      final model = await remoteDataSource.getOtherProfileContent(
        userId: userId,
        tab: tab,
        cursor: cursor,
      );

      debugPrint("← remoteDataSource.getOtherProfileContent success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileContent ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileContent CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileContent Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب محتوى الملف الشخصي الآخر',
        ),
      );
    }
  }
}
