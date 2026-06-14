// lib/features/other_profile/domain/repositories/other_profile_repository.dart

import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
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
}
