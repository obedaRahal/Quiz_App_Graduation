import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_purchased_tests_params.dart';

class FetchPurchasedTestsUseCase {
  final SettingsRepository settingsRepository;

  const FetchPurchasedTestsUseCase({required this.settingsRepository});

  Future<Either<Failure, PurchasedTestsEntity>> call(
    FetchPurchasedTestsParams params,
  ) {
    return settingsRepository.fetchPurchasedTests(params);
  }
}
