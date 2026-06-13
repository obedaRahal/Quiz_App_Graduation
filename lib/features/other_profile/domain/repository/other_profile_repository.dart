// lib/features/other_profile/domain/repositories/other_profile_repository.dart

import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import '../entities/other_profile_overview_entity.dart';

abstract class OtherProfileRepository {
  Future<Either<Failure, OtherProfileOverviewEntity>> getOtherProfileOverview({
    required int userId,
  });
}
