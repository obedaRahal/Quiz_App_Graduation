import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_tests_params.dart';

class FetchMyProfilePickerTestsUseCase {
  final MyProfileRepository repository;

  const FetchMyProfilePickerTestsUseCase(this.repository);

  Future<Either<Failure, MyProfilePickerTestsEntity>> call(
    FetchMyProfilePickerTestsParams params,
  ) {
    debugPrint("============ FetchMyProfilePickerTestsUseCase.call ============");
    debugPrint(
      "→ params: {userId: ${params.userId}, tab: ${params.tab}, cursor: ${params.cursor}}",
    );

    return repository.fetchMyProfilePickerTests(
      userId: params.userId,
      tab: params.tab,
      cursor: params.cursor,
    );
  }
}