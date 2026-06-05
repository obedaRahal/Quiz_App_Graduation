import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/add_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/delete_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/download_test_file_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_test_share_link_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/delete_review_feedback_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/download_test_file_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_test_share_link_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/review_feedback_action_params.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_reviews_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_status_history_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_details_overview_params.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_reviews_params.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/params/get_my_public_test_status_history_params.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';

class MyTestDetailsCubit extends Cubit<MyTestDetailsState> {
  final GetMyPublicTestDetailsOverviewUseCase
  getMyPublicTestDetailsOverviewUseCase;
  final GetMyPublicTestStatusHistoryUseCase getMyPublicTestStatusHistoryUseCase;
  final GetMyPublicTestReviewsUseCase getMyPublicTestReviewsUseCase;

  final AddFeedbackOnReviewUseCase addFeedbackOnReviewUseCase;
  final DeleteFeedbackOnReviewUseCase deleteFeedbackOnReviewUseCase;

  final DownloadTestFileUseCase downloadTestFileUseCase;
  final GetTestShareLinkUseCase getTestShareLinkUseCase;

  MyTestDetailsCubit({
    required this.getMyPublicTestDetailsOverviewUseCase,
    required this.getMyPublicTestStatusHistoryUseCase,
    required this.getMyPublicTestReviewsUseCase,
    required this.addFeedbackOnReviewUseCase,
    required this.deleteFeedbackOnReviewUseCase,
    required this.downloadTestFileUseCase,
    required this.getTestShareLinkUseCase,
  }) : super(const MyTestDetailsState()) {
    debugPrint("============ MyTestDetailsCubit INIT ============");
  }

  void changeSelectedTab(MyTestDetailsTab tab) {
    debugPrint(
      "============ MyTestDetailsCubit.changeSelectedTab ============",
    );
    debugPrint("→ selected tab: $tab");

    emit(state.copyWith(selectedTab: tab));

    debugPrint("=================================================");
  }

  void selectSampleAnswer({required int questionId, required int optionId}) {
    debugPrint(
      "============ MyTestDetailsCubit.selectSampleAnswer ============",
    );
    debugPrint("→ questionId: $questionId");
    debugPrint("→ optionId: $optionId");

    if (state.selectedSampleAnswers.containsKey(questionId)) {
      debugPrint("✗ answer already selected for this question");
      debugPrint("=================================================");
      return;
    }

    final updatedAnswers = Map<int, int>.from(state.selectedSampleAnswers);
    updatedAnswers[questionId] = optionId;

    emit(state.copyWith(selectedSampleAnswers: updatedAnswers));

    debugPrint("✓ sample answer selected");
    debugPrint("=================================================");
  }

  void changeSelectedRatingFilter(String rating) {
    debugPrint(
      "============ MyTestDetailsCubit.changeSelectedRatingFilter ============",
    );
    debugPrint("→ rating: $rating");

    emit(state.copyWith(selectedRatingFilter: rating));

    debugPrint("=================================================");
  }

  Future<void> getMyPublicTestDetailsOverview({required int testId}) async {
    debugPrint(
      "============ MyTestDetailsCubit.getMyPublicTestDetailsOverview ============",
    );
    debugPrint("→ params: {testId: $testId}");

    emit(
      state.copyWith(
        overviewStatus: MyPublicTestDetailsOverviewStatus.loading,
        clearError: true,
      ),
    );

    final result = await getMyPublicTestDetailsOverviewUseCase(
      GetMyPublicTestDetailsOverviewParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ my public test details overview failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            overviewStatus: MyPublicTestDetailsOverviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ my public test details overview loaded successfully");
        debugPrint("→ test id: ${response.data.id}");
        debugPrint("→ test title: ${response.data.basicInfo.title}");
        debugPrint(
          "→ preview questions count: ${response.data.extraInfo.previewQuestions.length}",
        );

        emit(
          state.copyWith(
            overviewStatus: MyPublicTestDetailsOverviewStatus.success,
            overviewDetails: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> getMyPublicTestStatusHistory({
    required int testId,
    bool forceRefresh = false,
  }) async {
    debugPrint(
      "============ MyTestDetailsCubit.getMyPublicTestStatusHistory ============",
    );
    debugPrint("→ params: {testId: $testId, forceRefresh: $forceRefresh}");

    if (state.isStatusHistoryLoading) {
      debugPrint("✗ status history already loading");
      debugPrint("=================================================");
      return;
    }

    if (!forceRefresh && state.statusHistoryDetails != null) {
      debugPrint("✓ status history already loaded, skip request");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        statusHistoryStatus: MyPublicTestStatusHistoryStatus.loading,
        clearError: true,
      ),
    );

    final result = await getMyPublicTestStatusHistoryUseCase(
      GetMyPublicTestStatusHistoryParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ my public test status history failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            statusHistoryStatus: MyPublicTestStatusHistoryStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ my public test status history loaded successfully");
        debugPrint("→ history count: ${response.data.length}");
        debugPrint("→ current status: ${response.currentStatus?.title}");
        debugPrint(
          "→ previous statuses count: ${response.previousStatuses.length}",
        );

        emit(
          state.copyWith(
            statusHistoryStatus: MyPublicTestStatusHistoryStatus.success,
            statusHistoryDetails: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> getMyPublicTestReviews({
    required int testId,
    String rating = 'all',
    int page = 1,
    bool loadMore = false,
  }) async {
    debugPrint(
      "============ MyTestDetailsCubit.getMyPublicTestReviews ============",
    );
    debugPrint(
      "→ params: {testId: $testId, rating: $rating, page: $page, loadMore: $loadMore}",
    );

    final currentReviewsDetails = state.reviewsDetails;

    if (loadMore) {
      if (state.isReviewsLoadMoreLoading || state.isReviewsLoading) {
        debugPrint("✗ reviews load more already loading");
        debugPrint("=================================================");
        return;
      }

      final meta = currentReviewsDetails?.data.meta;

      if (meta == null || !meta.hasMorePages) {
        debugPrint("✗ no more review pages");
        debugPrint("=================================================");
        return;
      }

      page = meta.currentPage + 1;

      emit(
        state.copyWith(
          reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.loading,
          clearError: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          reviewsStatus: MyPublicTestReviewsStatus.loading,
          reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.initial,
          selectedRatingFilter: rating,
          clearError: true,
        ),
      );
    }

    final result = await getMyPublicTestReviewsUseCase(
      GetMyPublicTestReviewsParams(testId: testId, rating: rating, page: page),
    );

    result.fold(
      (failure) {
        debugPrint("✗ my public test reviews failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        if (loadMore) {
          emit(
            state.copyWith(
              reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              reviewsStatus: MyPublicTestReviewsStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (response) {
        debugPrint("✓ my public test reviews loaded successfully");
        debugPrint("→ average rating: ${response.data.summary.averageRating}");
        debugPrint("→ new reviews count: ${response.data.reviews.length}");
        debugPrint("→ selected filter: $rating");
        debugPrint("→ page: ${response.data.meta.currentPage}");
        debugPrint("→ hasMorePages: ${response.data.meta.hasMorePages}");

        if (loadMore && currentReviewsDetails != null) {
          final oldReviews = currentReviewsDetails.data.reviews;
          final newReviews = response.data.reviews;

          final mergedReviews = [...oldReviews, ...newReviews];

          final mergedResponse = response.copyWith(
            data: response.data.copyWith(
              summary: response.data.summary,
              reviews: mergedReviews,
              meta: response.data.meta,
            ),
          );

          emit(
            state.copyWith(
              reviewsStatus: MyPublicTestReviewsStatus.success,
              reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.success,
              reviewsDetails: mergedResponse,
              selectedRatingFilter: rating,
              clearError: true,
            ),
          );

          debugPrint("✓ my public reviews merged successfully");
          debugPrint("→ old reviews count: ${oldReviews.length}");
          debugPrint("→ new reviews count: ${newReviews.length}");
          debugPrint("→ merged reviews count: ${mergedReviews.length}");
          debugPrint("=================================================");
          return;
        }

        emit(
          state.copyWith(
            reviewsStatus: MyPublicTestReviewsStatus.success,
            reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.initial,
            reviewsDetails: response,
            selectedRatingFilter: rating,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetReviewsLoadMoreState() {
    debugPrint(
      "============ MyTestDetailsCubit.resetReviewsLoadMoreState ============",
    );

    emit(
      state.copyWith(
        reviewsLoadMoreStatus: MyPublicTestReviewsLoadMoreStatus.initial,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }

  Future<void> toggleMyPublicReviewFeedback({
    required int reviewId,
    required bool vote,
  }) async {
    debugPrint(
      "============ MyTestDetailsCubit.toggleMyPublicReviewFeedback ============",
    );
    debugPrint("→ params: {reviewId: $reviewId, vote: ${vote ? 'yes' : 'no'}}");

    final reviewsDetails = state.reviewsDetails;

    if (reviewsDetails == null) {
      debugPrint("✗ reviewsDetails is null");
      debugPrint("=================================================");
      return;
    }

    if (state.activeFeedbackReviewId == reviewId &&
        state.isReviewFeedbackLoading) {
      debugPrint("✗ feedback action already loading for this review");
      debugPrint("=================================================");
      return;
    }

    final reviews = reviewsDetails.data.reviews;
    final reviewIndex = reviews.indexWhere((review) => review.id == reviewId);

    if (reviewIndex == -1) {
      debugPrint("✗ review not found");
      debugPrint("=================================================");
      return;
    }

    final review = reviews[reviewIndex];
    final currentVote = review.viewerFeedback?.vote;
    final normalizedCurrentVote = currentVote?.trim().toLowerCase();

    final requestedVote = vote ? 'yes' : 'no';

    final shouldDelete =
        review.viewerFeedback?.hasVoted == true &&
        normalizedCurrentVote == requestedVote;

    debugPrint("→ current hasVoted: ${review.viewerFeedback?.hasVoted}");
    debugPrint("→ current vote: $normalizedCurrentVote");
    debugPrint("→ requestedVote: $requestedVote");
    debugPrint("→ action: ${shouldDelete ? 'DELETE' : 'POST'}");

    emit(
      state.copyWith(
        reviewFeedbackStatus: MyPublicReviewFeedbackActionStatus.loading,
        activeFeedbackReviewId: reviewId,
        clearError: true,
      ),
    );

    final result = shouldDelete
        ? await deleteFeedbackOnReviewUseCase(
            DeleteReviewFeedbackParams(reviewId: reviewId),
          )
        : await addFeedbackOnReviewUseCase(
            ReviewFeedbackActionParams(reviewId: reviewId, vote: requestedVote),
          );

    result.fold(
      (failure) {
        debugPrint("✗ toggleMyPublicReviewFeedback failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            reviewFeedbackStatus: MyPublicReviewFeedbackActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveFeedbackReviewId: true,
          ),
        );
      },
      (response) {
        debugPrint("✓ toggleMyPublicReviewFeedback success");
        debugPrint("→ message: ${response.message}");

        final updatedReview = _buildUpdatedMyPublicReviewAfterFeedback(
          review: review,
          requestedVote: requestedVote,
          shouldDelete: shouldDelete,
        );

        final updatedReviews = List<MyPublicTestReviewEntity>.from(reviews);
        updatedReviews[reviewIndex] = updatedReview;

        final updatedReviewsDetails = reviewsDetails.copyWith(
          data: reviewsDetails.data.copyWith(reviews: updatedReviews),
        );

        emit(
          state.copyWith(
            reviewFeedbackStatus: MyPublicReviewFeedbackActionStatus.success,
            reviewsDetails: updatedReviewsDetails,
            clearError: true,
            clearActiveFeedbackReviewId: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  MyPublicTestReviewEntity _buildUpdatedMyPublicReviewAfterFeedback({
    required MyPublicTestReviewEntity review,
    required String requestedVote,
    required bool shouldDelete,
  }) {
    final oldVote = review.viewerFeedback?.vote?.trim().toLowerCase();

    int updatedYesCount = review.yesCount;

    if (shouldDelete) {
      if (oldVote == 'yes') {
        updatedYesCount = (updatedYesCount - 1).clamp(0, 999999999);
      }

      return review.copyWith(
        yesCount: updatedYesCount,
        viewerFeedback: const MyPublicTestReviewViewerFeedbackEntity(
          hasVoted: false,
          vote: null,
        ),
      );
    }

    if (oldVote != 'yes' && requestedVote == 'yes') {
      updatedYesCount += 1;
    }

    if (oldVote == 'yes' && requestedVote == 'no') {
      updatedYesCount = (updatedYesCount - 1).clamp(0, 999999999);
    }

    return review.copyWith(
      yesCount: updatedYesCount,
      viewerFeedback: MyPublicTestReviewViewerFeedbackEntity(
        hasVoted: true,
        vote: requestedVote,
      ),
    );
  }

  void resetReviewFeedbackState() {
    emit(
      state.copyWith(
        reviewFeedbackStatus: MyPublicReviewFeedbackActionStatus.initial,
        clearActiveFeedbackReviewId: true,
        clearError: true,
      ),
    );
  }

  Future<void> downloadMyPublicTestFile({required int testId}) async {
    debugPrint(
      "============ MyTestDetailsCubit.downloadMyPublicTestFile ============",
    );
    debugPrint("→ params: {testId: $testId}");

    if (state.isDownloadLoading) {
      debugPrint("✗ download already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        downloadStatus: MyPublicTestDownloadStatus.loading,
        clearError: true,
      ),
    );

    final result = await downloadTestFileUseCase(
      DownloadTestFileParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ download my public test file failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            downloadStatus: MyPublicTestDownloadStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ download my public test file success");
        debugPrint("→ filePath: ${response.filePath}");
        debugPrint("→ fileName: ${response.fileName}");

        emit(
          state.copyWith(
            downloadStatus: MyPublicTestDownloadStatus.success,
            downloadedFilePath: response.filePath,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetDownloadState() {
    debugPrint(
      "============ MyTestDetailsCubit.resetDownloadState ============",
    );

    emit(
      state.copyWith(
        downloadStatus: MyPublicTestDownloadStatus.initial,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }

  Future<void> getMyPublicTestShareLink({required int testId}) async {
    debugPrint(
      "============ MyTestDetailsCubit.getMyPublicTestShareLink ============",
    );
    debugPrint("→ params: {testId: $testId}");

    if (state.isShareLinkLoading) {
      debugPrint("✗ share link already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        shareLinkStatus: MyPublicTestShareLinkStatus.loading,
        clearShareUrl: true,
        clearError: true,
      ),
    );

    final result = await getTestShareLinkUseCase(
      GetTestShareLinkParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ get my public test share link failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            shareLinkStatus: MyPublicTestShareLinkStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ get my public test share link success");
        debugPrint("→ shareUrl: ${response.data.shareUrl}");

        emit(
          state.copyWith(
            shareLinkStatus: MyPublicTestShareLinkStatus.success,
            shareUrl: response.data.shareUrl,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetShareLinkState() {
    debugPrint(
      "============ MyTestDetailsCubit.resetShareLinkState ============",
    );

    emit(
      state.copyWith(
        shareLinkStatus: MyPublicTestShareLinkStatus.initial,
        clearShareUrl: true,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }
}
