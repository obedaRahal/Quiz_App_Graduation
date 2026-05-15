import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/shared_test_link_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/get_shared_test_link_params.dart';

class GetSharedTestLinkUseCase {
  final DetailsOfTestRepository repository;

  const GetSharedTestLinkUseCase(this.repository);

  Future<Either<Failure, SharedTestLinkEntity>> call(
    GetSharedTestLinkParams params,
  ) {
    debugPrint("============ GetSharedTestLinkUseCase.call ============");
    debugPrint("→ params: {slug: ${params.slug}}");

    return repository.getSharedTestLink(
      slug: params.slug,
    );
  }
}