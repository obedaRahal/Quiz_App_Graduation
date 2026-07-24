import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_sold_tests_params.dart';

class FetchSoldTestsUseCase {
  final SettingsRepository settingsRepository;

  const FetchSoldTestsUseCase({required this.settingsRepository});

  Future<Either<Failure, SoldTestsEntity>> call(
    FetchSoldTestsParams params,
  ) async {
    debugPrint('============ FetchSoldTestsUseCase.call ============');
    debugPrint('→ tab: ${params.tab}');

    final result = await settingsRepository.fetchSoldTests(params);

    result.fold(
      (failure) {
        debugPrint('✗ title: ${failure.title}');
        debugPrint('✗ message: ${failure.message}');
      },
      (soldTests) {
        debugPrint('√ totalSalesCount: ${soldTests.stats.totalSalesCount}');
        debugPrint(
          '√ totalSellerNetAmountSyp: '
          '${soldTests.stats.totalSellerNetAmountSyp}',
        );
        debugPrint('√ sales count: ${soldTests.sales.length}');
      },
    );

    debugPrint('=================================================');

    return result;
  }
}
