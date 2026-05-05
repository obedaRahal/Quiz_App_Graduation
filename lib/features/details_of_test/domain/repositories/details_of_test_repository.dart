import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/other_test_details_overview_entity.dart';

abstract class DetailsOfTestRepository {
  Future<Either<Failure, OtherTestDetailsOverviewEntity>>
      getOtherTestDetailsOverview({
    required int testId,
  });
}