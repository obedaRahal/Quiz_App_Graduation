import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/bookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_reviews_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_sample_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/like_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_overview_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_reviews_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_sample_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_like_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unbookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unlike_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';

class DetailsOfTestCubit extends Cubit<DetailsOfTestState> {
  final GetOtherTestDetailsOverviewUseCase getOtherTestDetailsOverviewUseCase;
  final GetOtherTestDetailsSampleUseCase getOtherTestDetailsSampleUseCase;
  final GetOtherTestDetailsReviewsUseCase getOtherTestDetailsReviewsUseCase;
  final LikeTestUseCase likeTestUseCase;
  final UnlikeTestUseCase unlikeTestUseCase;
  final BookmarkTestUseCase bookmarkTestUseCase;
  final UnbookmarkTestUseCase unbookmarkTestUseCase;
  final FollowCreatorUseCase followCreatorUseCase;
  final UnfollowCreatorUseCase unfollowCreatorUseCase;

  DetailsOfTestCubit({
    required this.getOtherTestDetailsOverviewUseCase,
    required this.getOtherTestDetailsSampleUseCase,
    required this.getOtherTestDetailsReviewsUseCase,
    required this.likeTestUseCase,
    required this.unlikeTestUseCase,
    required this.bookmarkTestUseCase,
    required this.unbookmarkTestUseCase,
    required this.followCreatorUseCase,
    required this.unfollowCreatorUseCase,
  }) : super(const DetailsOfTestState()) {
    debugPrint("============ DetailsOfTestCubit INIT ============");
  }

  void changeSelectedTab(DetailsOfTestTab tab) {
    debugPrint(
      "============ DetailsOfTestCubit.changeSelectedTab ============",
    );
    debugPrint("→ selected tab: $tab");

    emit(state.copyWith(selectedTab: tab));

    debugPrint("=================================================");
  }

  void selectSampleAnswer({required int questionId, required int optionId}) {
    debugPrint(
      "============ DetailsOfTestCubit.selectSampleAnswer ============",
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

  void changeDraftReviewRating(int rating) {
    debugPrint(
      "============ DetailsOfTestCubit.changeDraftReviewRating ============",
    );
    debugPrint("→ rating: $rating");

    emit(state.copyWith(draftReviewRating: rating));

    debugPrint("=================================================");
  }

  void changeDraftReviewText(String text) {
    if (text.length > 200) return;

    emit(state.copyWith(draftReviewText: text));
  }

  void submitDraftReview({required int testId}) {
    debugPrint(
      "============ DetailsOfTestCubit.submitDraftReview ============",
    );
    debugPrint("→ testId: $testId");
    debugPrint("→ rating: ${state.draftReviewRating}");
    debugPrint("→ reviewText: ${state.draftReviewText}");

    if (state.draftReviewRating <= 0) {
      debugPrint("✗ rating is required");
      debugPrint("=================================================");
      return;
    }

    // لاحقًا هنا API نشر التقييم
    debugPrint("✓ ready to submit review");
    debugPrint("=================================================");
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

  Future<void> toggleTestLike({required int testId}) async {
    debugPrint("============ DetailsOfTestCubit.toggleTestLike ============");
    debugPrint("→ params: {testId: $testId}");

    final overview = state.overviewDetails;

    if (overview == null) {
      debugPrint("✗ overviewDetails is null, cannot toggle like");
      debugPrint("=================================================");
      return;
    }

    if (state.isLikeActionLoading) {
      debugPrint("✗ like action already loading");
      debugPrint("=================================================");
      return;
    }

    final currentHasLiked = overview.data.extraInfo.viewerContext.hasLiked;

    final currentLikesCount = overview.data.basicInfo.likesCount;

    debugPrint("→ currentHasLiked: $currentHasLiked");
    debugPrint("→ currentLikesCount: $currentLikesCount");

    emit(
      state.copyWith(
        likeActionStatus: TestLikeActionStatus.loading,
        clearError: true,
      ),
    );

    final result = currentHasLiked
        ? await unlikeTestUseCase(TestLikeActionParams(testId: testId))
        : await likeTestUseCase(TestLikeActionParams(testId: testId));

    result.fold(
      (failure) {
        debugPrint("✗ toggle like failure title: ${failure.title}");
        debugPrint("✗ toggle like failure message: ${failure.message}");

        emit(
          state.copyWith(
            likeActionStatus: TestLikeActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newHasLiked = response.data.hasLiked;

        final int updatedLikesCount;
        if (newHasLiked == currentHasLiked) {
          updatedLikesCount = currentLikesCount;
        } else if (newHasLiked) {
          updatedLikesCount = currentLikesCount + 1;
        } else {
          updatedLikesCount = (currentLikesCount - 1).clamp(0, 999999999);
        }

        debugPrint("✓ toggle like success");
        debugPrint("→ newHasLiked: $newHasLiked");
        debugPrint("→ updatedLikesCount: $updatedLikesCount");

        final updatedOverview = overview.copyWith(
          data: overview.data.copyWith(
            basicInfo: overview.data.basicInfo.copyWith(
              likesCount: updatedLikesCount,
            ),
            extraInfo: overview.data.extraInfo.copyWith(
              viewerContext: overview.data.extraInfo.viewerContext.copyWith(
                hasLiked: newHasLiked,
              ),
            ),
          ),
        );

        emit(
          state.copyWith(
            likeActionStatus: TestLikeActionStatus.success,
            overviewDetails: updatedOverview,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> toggleTestBookmark({required int testId}) async {
    debugPrint(
      "============ DetailsOfTestCubit.toggleTestBookmark ============",
    );
    debugPrint("→ params: {testId: $testId}");

    final overview = state.overviewDetails;

    if (overview == null) {
      debugPrint("✗ overviewDetails is null, cannot toggle bookmark");
      debugPrint("=================================================");
      return;
    }

    if (state.isBookmarkActionLoading) {
      debugPrint("✗ bookmark action already loading");
      debugPrint("=================================================");
      return;
    }

    final currentHasBookmarked =
        overview.data.extraInfo.viewerContext.hasBookmarked;

    final currentBookmarksCount = overview.data.basicInfo.bookmarksCount;

    debugPrint("→ currentHasBookmarked: $currentHasBookmarked");
    debugPrint("→ currentBookmarksCount: $currentBookmarksCount");

    emit(
      state.copyWith(
        bookmarkActionStatus: TestBookmarkActionStatus.loading,
        clearError: true,
      ),
    );

    final result = currentHasBookmarked
        ? await unbookmarkTestUseCase(TestBookmarkActionParams(testId: testId))
        : await bookmarkTestUseCase(TestBookmarkActionParams(testId: testId));

    result.fold(
      (failure) {
        debugPrint("✗ toggle bookmark failure title: ${failure.title}");
        debugPrint("✗ toggle bookmark failure message: ${failure.message}");

        emit(
          state.copyWith(
            bookmarkActionStatus: TestBookmarkActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newHasBookmarked = response.data.hasBookmarked;

        final int updatedBookmarksCount;
        if (newHasBookmarked == currentHasBookmarked) {
          updatedBookmarksCount = currentBookmarksCount;
        } else if (newHasBookmarked) {
          updatedBookmarksCount = currentBookmarksCount + 1;
        } else {
          updatedBookmarksCount = (currentBookmarksCount - 1).clamp(
            0,
            999999999,
          );
        }

        debugPrint("✓ toggle bookmark success");
        debugPrint("→ newHasBookmarked: $newHasBookmarked");
        debugPrint("→ updatedBookmarksCount: $updatedBookmarksCount");

        final updatedOverview = overview.copyWith(
          data: overview.data.copyWith(
            basicInfo: overview.data.basicInfo.copyWith(
              bookmarksCount: updatedBookmarksCount,
            ),
            extraInfo: overview.data.extraInfo.copyWith(
              viewerContext: overview.data.extraInfo.viewerContext.copyWith(
                hasBookmarked: newHasBookmarked,
              ),
            ),
          ),
        );

        emit(
          state.copyWith(
            bookmarkActionStatus: TestBookmarkActionStatus.success,
            overviewDetails: updatedOverview,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> toggleCreatorFollow({required int creatorId}) async {
    debugPrint(
      "============ DetailsOfTestCubit.toggleCreatorFollow ============",
    );
    debugPrint("→ params: {creatorId: $creatorId}");

    final overview = state.overviewDetails;

    if (overview == null) {
      debugPrint("✗ overviewDetails is null, cannot toggle follow");
      debugPrint("=================================================");
      return;
    }

    if (state.isFollowActionLoading) {
      debugPrint("✗ follow action already loading");
      debugPrint("=================================================");
      return;
    }

    final currentIsFollowing =
        overview.data.extraInfo.viewerContext.isFollowingCreator;

    final currentFollowersCount = overview.data.creator.followersCount;

    debugPrint("→ currentIsFollowing: $currentIsFollowing");
    debugPrint("→ currentFollowersCount: $currentFollowersCount");

    emit(
      state.copyWith(
        followActionStatus: FollowActionStatus.loading,
        clearError: true,
      ),
    );

    final result = currentIsFollowing
        ? await unfollowCreatorUseCase(
            TestFollowActionParams(creatorId: creatorId),
          )
        : await followCreatorUseCase(
            TestFollowActionParams(creatorId: creatorId),
          );

    result.fold(
      (failure) {
        debugPrint("✗ toggle follow failure title: ${failure.title}");
        debugPrint("✗ toggle follow failure message: ${failure.message}");

        emit(
          state.copyWith(
            followActionStatus: FollowActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newIsFollowing = !currentIsFollowing;

        final int updatedFollowersCount;
        if (newIsFollowing == currentIsFollowing) {
          updatedFollowersCount = currentFollowersCount;
        } else if (newIsFollowing) {
          updatedFollowersCount = currentFollowersCount + 1;
        } else {
          updatedFollowersCount = (currentFollowersCount - 1).clamp(
            0,
            999999999,
          );
        }

        debugPrint("✓ toggle follow success");
        debugPrint("→ response message: ${response.message}");
        debugPrint("→ newIsFollowing: $newIsFollowing");
        debugPrint("→ updatedFollowersCount: $updatedFollowersCount");

        final updatedOverview = overview.copyWith(
          data: overview.data.copyWith(
            creator: overview.data.creator.copyWith(
              followersCount: updatedFollowersCount,
            ),
            extraInfo: overview.data.extraInfo.copyWith(
              viewerContext: overview.data.extraInfo.viewerContext.copyWith(
                isFollowingCreator: newIsFollowing,
              ),
            ),
          ),
        );

        emit(
          state.copyWith(
            followActionStatus: FollowActionStatus.success,
            overviewDetails: updatedOverview,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }
}
