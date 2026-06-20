// lib/features/other_profile/data/repo_impl/other_profile_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart'; // تأكد من مسار الـ Exceptions الفعلي في مشروعك
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/content_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/folder_bookmark_action_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_academic_certificate_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_receive_entitiy.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_share_link_entity.dart';
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

  @override
  Future<Either<Failure, FolderBookmarkActionEntity>> saveFolderBookmark({
    required int folderId,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.saveFolderBookmark ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    try {
      debugPrint("→ calling remoteDataSource.saveFolderBookmark");

      final model = await remoteDataSource.saveFolderBookmark(
        folderId: folderId,
      );

      debugPrint("← remoteDataSource.saveFolderBookmark success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.saveFolderBookmark ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.saveFolderBookmark CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.saveFolderBookmark Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء حفظ القائمة',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, FolderBookmarkActionEntity>> removeFolderBookmark({
    required int folderId,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.removeFolderBookmark ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    try {
      debugPrint("→ calling remoteDataSource.removeFolderBookmark");

      final model = await remoteDataSource.removeFolderBookmark(
        folderId: folderId,
      );

      debugPrint("← remoteDataSource.removeFolderBookmark success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.removeFolderBookmark ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.removeFolderBookmark CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.removeFolderBookmark Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء إزالة القائمة من المحفوظات',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ContentBookmarkActionEntity>> saveContentBookmark({
    required int contentId,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.saveContentBookmark ============",
    );
    debugPrint("→ params: {contentId: $contentId}");

    try {
      debugPrint("→ calling remoteDataSource.saveContentBookmark");

      final model = await remoteDataSource.saveContentBookmark(
        contentId: contentId,
      );

      debugPrint("← remoteDataSource.saveContentBookmark success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء حفظ المحتوى',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ContentBookmarkActionEntity>> removeContentBookmark({
    required int contentId,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.removeContentBookmark ============",
    );
    debugPrint("→ params: {contentId: $contentId}");

    try {
      debugPrint("→ calling remoteDataSource.removeContentBookmark");

      final model = await remoteDataSource.removeContentBookmark(
        contentId: contentId,
      );

      debugPrint("← remoteDataSource.removeContentBookmark success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء إزالة المحتوى من المحفوظات',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileFolderDetailsEntity>>
  getOtherProfileFolderDetails({required int folderId}) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileFolderDetails ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileFolderDetails");

      final model = await remoteDataSource.getOtherProfileFolderDetails(
        folderId: folderId,
      );

      debugPrint("← remoteDataSource.getOtherProfileFolderDetails success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب تفاصيل القائمة',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileShareLinkEntity>>
  getOtherProfileShareLink({required int userId}) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileShareLink ============",
    );
    debugPrint("→ params: {userId: $userId}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileShareLink");

      final model = await remoteDataSource.getOtherProfileShareLink(
        userId: userId,
      );

      debugPrint("← remoteDataSource.getOtherProfileShareLink success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء تجهيز رابط مشاركة الملف الشخصي',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileReceiveEntity>> getOtherProfileReceive({
    required String slug,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileReceive ============",
    );
    debugPrint("→ params: {slug: $slug}");

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileReceive");

      final model = await remoteDataSource.getOtherProfileReceive(slug: slug);

      debugPrint("← remoteDataSource.getOtherProfileReceive success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء فتح رابط الملف الشخصي',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileConnectionsResponseEntity>>
  getOtherProfileConnections({
    required int userId,
    required OtherProfileConnectionsType type,
    String search = '',
    String? cursor,
  }) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileConnections ============",
    );
    debugPrint(
      "→ params: {userId: $userId, type: $type, search: $search, cursor: $cursor}",
    );

    try {
      debugPrint("→ calling remoteDataSource.getOtherProfileConnections");

      final model = await remoteDataSource.getOtherProfileConnections(
        userId: userId,
        type: type,
        search: search,
        cursor: cursor,
      );

      debugPrint("← remoteDataSource.getOtherProfileConnections success");
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileConnections ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileConnections CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileConnections Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب قائمة المستخدمين',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OtherProfileAcademicCertificateEntity>>
  getOtherProfileAcademicCertificate({required int userId}) async {
    debugPrint(
      "============ OtherProfileRepositoryImpl.getOtherProfileAcademicCertificate ============",
    );
    debugPrint("→ params: {userId: $userId}");

    try {
      debugPrint(
        "→ calling remoteDataSource.getOtherProfileAcademicCertificate",
      );

      final model = await remoteDataSource.getOtherProfileAcademicCertificate(
        userId: userId,
      );

      debugPrint(
        "← remoteDataSource.getOtherProfileAcademicCertificate success",
      );
      debugPrint("=================================================");

      return Right(model);
    } on ServerException catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileAcademicCertificate ServerException: ${e.errorModel.errorMessage}",
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
        "✗ OtherProfileRepositoryImpl.getOtherProfileAcademicCertificate CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OtherProfileRepositoryImpl.getOtherProfileAcademicCertificate Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب الشهادة الجامعية',
        ),
      );
    }
  }
}
