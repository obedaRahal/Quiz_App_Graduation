import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_other_test_details_overview_use_case.dart';
import '../../../domain/use_cases/params/get_other_test_details_overview_params.dart';
import 'details_of_test_cubit_state.dart';

class DetailsOfTestCubit extends Cubit<DetailsOfTestState> {
  final GetOtherTestDetailsOverviewUseCase getOtherTestDetailsOverviewUseCase;

  DetailsOfTestCubit({
    required this.getOtherTestDetailsOverviewUseCase,
  }) : super(const DetailsOfTestState()) {
    debugPrint("============ DetailsOfTestCubit INIT ============");
  }

  Future<void> getOtherTestDetailsOverview({
    required int testId,
  }) async {
    debugPrint(
      "============ DetailsOfTestCubit.getOtherTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    emit(
      state.copyWith(
        overviewStatus: DetailsOfTestOverviewStatus.loading,
        clearError: true,
      ),
    );

    final result = await getOtherTestDetailsOverviewUseCase(
      GetOtherTestDetailsOverviewParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ overview failure title: ${failure.title}");
        debugPrint("✗ overview failure message: ${failure.message}");

        emit(
          state.copyWith(
            overviewStatus: DetailsOfTestOverviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ overview loaded successfully");
        debugPrint("→ test title: ${response.data.basicInfo.title}");
        debugPrint("→ test id: ${response.data.id}");

        emit(
          state.copyWith(
            overviewStatus: DetailsOfTestOverviewStatus.success,
            overviewDetails: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }
}