import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/test_share_link_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/get_test_share_link_params.dart';

class GetTestShareLinkUseCase {
  final DetailsOfTestRepository repository;

  const GetTestShareLinkUseCase(this.repository);

  Future<Either<Failure, TestShareLinkEntity>> call(
    GetTestShareLinkParams params,
  ) {
    debugPrint("============ GetTestShareLinkUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.getTestShareLink(
      testId: params.testId,
    );
  }
}