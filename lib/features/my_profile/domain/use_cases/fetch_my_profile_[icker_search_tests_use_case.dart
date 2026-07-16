import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_search_tests_params.dart';

class FetchMyProfilePickerSearchTestsUseCase {
  final MyProfileRepository repository;

  const FetchMyProfilePickerSearchTestsUseCase(this.repository);

  Future<Either<Failure, MyProfilePickerSearchTestsEntity>> call(
    FetchMyProfilePickerSearchTestsParams params,
  ) {
    debugPrint(
      "============ FetchMyProfilePickerSearchTestsUseCase.call ============",
    );
    debugPrint("→ params: {query: ${params.query}, page: ${params.page}}");

    return repository.fetchMyProfilePickerSearchTests(
      query: params.query,
      page: params.page,
    );
  }
}