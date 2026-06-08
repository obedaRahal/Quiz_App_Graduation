import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/delete_my_test_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/delete_my_test_params.dart';

class DeleteMyTestUseCase {
  final MyPublicTestDetailsRepository repository;

  const DeleteMyTestUseCase(this.repository);

  Future<Either<Failure, DeleteMyTestEntity>> call(
    DeleteMyTestParams params,
  ) {
    debugPrint("============ DeleteMyTestUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.deleteMyTest(
      testId: params.testId,
    );
  }
}