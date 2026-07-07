import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/data/data_source/my_profile_remote_data_source.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/delete_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_academic_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_personal_info_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_picture_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/edit_my_profile_scientific_interests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';

class MyProfileRepositoryImpl implements MyProfileRepository {
  final MyProfileRemoteDataSource remoteDataSource;

  const MyProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MyProfileEntity>> getMyProfilePersonalInfo({
    required int userId,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.getMyProfilePersonalInfo ============",
    );
    debugPrint("→ params: {userId: $userId}");

    try {
      final response = await remoteDataSource.getMyProfilePersonalInfo(
        userId: userId,
      );

      debugPrint("✓ getMyProfilePersonalInfo success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ getMyProfilePersonalInfo ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint("✗ getMyProfilePersonalInfo CacheException");
      debugPrint("→ message: ${e.errorMessage}");
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ getMyProfilePersonalInfo Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب بيانات الملف الشخصي',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EditMyProfilePersonalInfoEntity>>
  editMyProfilePersonalInfo({
    required int userId,
    required Map<String, dynamic> changedFields,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.editMyProfilePersonalInfo ============",
    );
    debugPrint("→ params: {userId: $userId}");
    debugPrint("→ changedFields: $changedFields");

    try {
      final response = await remoteDataSource.editMyProfilePersonalInfo(
        userId: userId,
        changedFields: changedFields,
      );

      debugPrint("✓ editMyProfilePersonalInfo success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ editMyProfilePersonalInfo ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint("✗ editMyProfilePersonalInfo CacheException");
      debugPrint("→ message: ${e.errorMessage}");
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ editMyProfilePersonalInfo Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تعديل المعلومات الشخصية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EditMyProfileAcademicInfoEntity>>
  editMyProfileAcademicInfo({
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.editMyProfileAcademicInfo ============",
    );
    debugPrint("→ params: {userId: $userId}");
    debugPrint("→ data: $data");

    try {
      final response = await remoteDataSource.editMyProfileAcademicInfo(
        userId: userId,
        data: data,
      );

      debugPrint("✓ editMyProfileAcademicInfo success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ editMyProfileAcademicInfo ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint("✗ editMyProfileAcademicInfo CacheException");
      debugPrint("→ message: ${e.errorMessage}");
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ editMyProfileAcademicInfo Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تعديل المعلومات الدراسية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EditMyProfileScientificInterestsEntity>>
  editMyProfileScientificInterests({
    required int userId,
    required List<int> interestIds,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.editMyProfileScientificInterests ============",
    );
    debugPrint("→ params: {userId: $userId}");
    debugPrint("→ interestIds: $interestIds");

    try {
      final response = await remoteDataSource.editMyProfileScientificInterests(
        userId: userId,
        interestIds: interestIds,
      );

      debugPrint("✓ editMyProfileScientificInterests success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ editMyProfileScientificInterests ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint("✗ editMyProfileScientificInterests CacheException");
      debugPrint("→ message: ${e.errorMessage}");
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ editMyProfileScientificInterests Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تعديل الاهتمامات العلمية',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, EditMyProfilePictureEntity>> editMyProfilePicture({
    required int userId,
    required String type,
    required String imagePath,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.editMyProfilePicture ============",
    );
    debugPrint("→ params: {userId: $userId, type: $type}");
    debugPrint("→ imagePath: $imagePath");

    try {
      final response = await remoteDataSource.editMyProfilePicture(
        userId: userId,
        type: type,
        imagePath: imagePath,
      );

      debugPrint("✓ editMyProfilePicture success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ editMyProfilePicture ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ editMyProfilePicture Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تحديث الصورة'),
      );
    }
  }

  @override
  Future<Either<Failure, DeleteMyProfilePictureEntity>> deleteMyProfilePicture({
    required int userId,
    required String type,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.deleteMyProfilePicture ============",
    );
    debugPrint("→ params: {userId: $userId, type: $type}");

    try {
      final response = await remoteDataSource.deleteMyProfilePicture(
        userId: userId,
        type: type,
      );

      debugPrint("✓ deleteMyProfilePicture success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ deleteMyProfilePicture ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ deleteMyProfilePicture Unexpected error: $e");
      debugPrint("=================================================");

      return Left(ServerFailure(title: 'حدث خطأ', message: 'تعذر حذف الصورة'));
    }
  }

  @override
  Future<Either<Failure, MyProfileBookmarksEntity>> fetchMyProfileBookmarks({
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.fetchMyProfileBookmarks ============",
    );
    debugPrint("→ tab: $tab");
    debugPrint("→ cursor: $cursor");

    try {
      final response = await remoteDataSource.fetchMyProfileBookmarks(
        tab: tab,
        cursor: cursor,
      );

      debugPrint("✓ fetchMyProfileBookmarks success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ fetchMyProfileBookmarks ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ fetchMyProfileBookmarks Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب المحفوظات'),
      );
    }
  }

  @override
  Future<Either<Failure, MyProfileLibraryEntity>> fetchMyProfileLibrary({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.fetchMyProfileLibrary ============",
    );
    debugPrint("→ userId: $userId");
    debugPrint("→ tab: $tab");
    debugPrint("→ cursor: $cursor");

    try {
      final response = await remoteDataSource.fetchMyProfileLibrary(
        userId: userId,
        tab: tab,
        cursor: cursor,
      );

      debugPrint("✓ fetchMyProfileLibrary success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ fetchMyProfileLibrary ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ fetchMyProfileLibrary Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب محتوى الملف الشخصي'),
      );
    }
  }

  @override
  Future<Either<Failure, MyProfileLibraryEntity>> searchMyProfileLibrary({
    required String query,
    required String mode,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.searchMyProfileLibrary ============",
    );
    debugPrint("→ query: $query");
    debugPrint("→ mode: $mode");
    debugPrint("→ cursor: $cursor");

    try {
      final response = await remoteDataSource.searchMyProfileLibrary(
        query: query,
        mode: mode,
        cursor: cursor,
      );

      debugPrint("✓ searchMyProfileLibrary success");
      debugPrint("=================================================");

      return Right(response);
    } on ServerException catch (e) {
      debugPrint("✗ searchMyProfileLibrary ServerException");
      debugPrint("→ title: ${e.errorModel.errorTitle}");
      debugPrint("→ message: ${e.errorModel.errorMessage}");
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint("✗ searchMyProfileLibrary Unexpected error: $e");
      debugPrint("=================================================");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر البحث في محتوى المكتبة'),
      );
    }
  }

  @override
  Future<Either<Failure, MyProfileFoldersEntity>> fetchMyProfileFolders({
    required int userId,
    required String tab,
    String? cursor,
  }) async {
    debugPrint(
      "============ MyProfileRepositoryImpl.fetchMyProfileFolders ============",
    );
    debugPrint("→ params: {userId: $userId, tab: $tab, cursor: $cursor}");

    try {
      debugPrint("→ calling remoteDataSource.fetchMyProfileFolders");

      final model = await remoteDataSource.fetchMyProfileFolders(
        userId: userId,
        tab: tab,
        cursor: cursor,
      );

      debugPrint("← remoteDataSource.fetchMyProfileFolders success");
      debugPrint("→ converting model to entity");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ MyProfileRepositoryImpl.fetchMyProfileFolders ServerException: ${e.errorModel.errorMessage}",
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
        "✗ MyProfileRepositoryImpl.fetchMyProfileFolders CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ MyProfileRepositoryImpl.fetchMyProfileFolders Unexpected error: $e",
      );
      debugPrint("=================================================");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'حدث خطأ غير متوقع أثناء جلب مجلدات الملف الشخصي',
        ),
      );
    }
  }
}
