// lib/features/other_profile/domain/repositories/other_profile_repository.dart

import 'package:dartz/dartz.dart';
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
import '../entities/other_profile_overview_entity.dart';

abstract class OtherProfileRepository {
  Future<Either<Failure, OtherProfileOverviewEntity>> getOtherProfileOverview({
    required int userId,
  });

  Future<Either<Failure, OtherProfileTestsResponseEntity>>
  getOtherProfileTests({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, OtherProfileFoldersResponseEntity>>
  getOtherProfileFolders({required int userId, String? cursor});

  Future<Either<Failure, OtherProfileContentResponseEntity>>
  getOtherProfileContent({
    required int userId,
    required String tab,
    String? cursor,
  });

  Future<Either<Failure, FolderBookmarkActionEntity>> saveFolderBookmark({
    required int folderId,
  });

  Future<Either<Failure, FolderBookmarkActionEntity>> removeFolderBookmark({
    required int folderId,
  });

  Future<Either<Failure, ContentBookmarkActionEntity>> saveContentBookmark({
    required int contentId,
  });

  Future<Either<Failure, ContentBookmarkActionEntity>> removeContentBookmark({
    required int contentId,
  });

  Future<Either<Failure, OtherProfileFolderDetailsEntity>>
  getOtherProfileFolderDetails({required int folderId});

  Future<Either<Failure, OtherProfileShareLinkEntity>>
  getOtherProfileShareLink({required int userId});

  Future<Either<Failure, OtherProfileReceiveEntity>> getOtherProfileReceive({
    required String slug,
  });

  Future<Either<Failure, OtherProfileConnectionsResponseEntity>>
  getOtherProfileConnections({
    required int userId,
    required OtherProfileConnectionsType type,
    String search = '',
    String? cursor,
  });

  Future<Either<Failure, OtherProfileAcademicCertificateEntity>>
  getOtherProfileAcademicCertificate({required int userId});
}
