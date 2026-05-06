import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_reviews_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_sample_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_reviews_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_sample_params.dart';

import '../../../domain/use_cases/get_other_test_details_overview_use_case.dart';
import '../../../domain/use_cases/params/get_other_test_details_overview_params.dart';
import 'details_of_test_cubit_state.dart';

class DetailsOfTestCubit extends Cubit<DetailsOfTestState> {
  final GetOtherTestDetailsOverviewUseCase getOtherTestDetailsOverviewUseCase;
  final GetOtherTestDetailsSampleUseCase getOtherTestDetailsSampleUseCase;
  final GetOtherTestDetailsReviewsUseCase getOtherTestDetailsReviewsUseCase;

  DetailsOfTestCubit({
    required this.getOtherTestDetailsOverviewUseCase,
    required this.getOtherTestDetailsSampleUseCase,
    required this.getOtherTestDetailsReviewsUseCase,
  }) : super(const DetailsOfTestState()) {
    debugPrint("============ DetailsOfTestCubit INIT ============");
  }

  Future<void> getOtherTestDetailsOverview({required int testId}) async {
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

  Future<void> getOtherTestDetailsSample({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestCubit.getOtherTestDetailsSample ============",
    );
    debugPrint("→ params: {testId: $testId}");

    emit(
      state.copyWith(
        sampleStatus: DetailsOfTestSampleStatus.loading,
        clearError: true,
      ),
    );

    final result = await getOtherTestDetailsSampleUseCase(
      GetOtherTestDetailsSampleParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ sample failure title: ${failure.title}");
        debugPrint("✗ sample failure message: ${failure.message}");

        emit(
          state.copyWith(
            sampleStatus: DetailsOfTestSampleStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ sample loaded successfully");
        debugPrint("→ questions count: ${response.questions.length}");

        emit(
          state.copyWith(
            sampleStatus: DetailsOfTestSampleStatus.success,
            sampleDetails: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> getOtherTestDetailsReviews({
    required int testId,
    String rating = 'all',
  }) async {
    debugPrint(
      "============ DetailsOfTestCubit.getOtherTestDetailsReviews ============",
    );
    debugPrint("→ params: {testId: $testId, rating: $rating}");

    emit(
      state.copyWith(
        reviewsStatus: DetailsOfTestReviewsStatus.loading,
        selectedRatingFilter: rating,
        clearError: true,
      ),
    );

    final result = await getOtherTestDetailsReviewsUseCase(
      GetOtherTestDetailsReviewsParams(testId: testId, rating: rating),
    );

    result.fold(
      (failure) {
        debugPrint("✗ reviews failure title: ${failure.title}");
        debugPrint("✗ reviews failure message: ${failure.message}");

        emit(
          state.copyWith(
            reviewsStatus: DetailsOfTestReviewsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ reviews loaded successfully");
        debugPrint("→ average rating: ${response.data.summary.averageRating}");
        debugPrint("→ reviews count: ${response.data.reviews.length}");
        debugPrint("→ selected filter: $rating");

        emit(
          state.copyWith(
            reviewsStatus: DetailsOfTestReviewsStatus.success,
            reviewsDetails: response,
            selectedRatingFilter: rating,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }
}
