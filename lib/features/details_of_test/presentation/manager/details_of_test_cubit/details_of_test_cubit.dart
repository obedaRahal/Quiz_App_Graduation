import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/add_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/add_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/bookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/delete_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/delete_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/download_test_file_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_reviews_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_sample_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_shared_test_link_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_test_share_link_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/like_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/add_test_review_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/delete_review_feedback_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/delete_test_review_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/download_test_file_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_overview_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_reviews_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_other_test_details_sample_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_shared_test_link_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_test_share_link_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/review_feedback_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_like_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/update_test_review_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/submit_report_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unbookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unlike_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/update_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_state.dart';

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
  final DownloadTestFileUseCase downloadTestFileUseCase;
  final AddTestReviewUseCase addTestReviewUseCase;
  final UpdateTestReviewUseCase updateTestReviewUseCase;

  final DeleteTestReviewUseCase deleteTestReviewUseCase;
  final AddFeedbackOnReviewUseCase addFeedbackOnReviewUseCase;
  final DeleteFeedbackOnReviewUseCase deleteFeedbackOnReviewUseCase;

  final SubmitReportUseCase submitReportUseCase;

  final GetTestShareLinkUseCase getTestShareLinkUseCase;

  final GetSharedTestLinkUseCase getSharedTestLinkUseCase;

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
    required this.downloadTestFileUseCase,
    required this.addTestReviewUseCase,
    required this.updateTestReviewUseCase,
    required this.deleteTestReviewUseCase,
    required this.addFeedbackOnReviewUseCase,
    required this.deleteFeedbackOnReviewUseCase,
    required this.submitReportUseCase,
    required this.getTestShareLinkUseCase,
    required this.getSharedTestLinkUseCase,
  }) : super(const DetailsOfTestState()) {
    debugPrint("============ DetailsOfTestCubit INIT ============");
  }
  ///////////////////// FOR UI ////////////////////////////
  ///////////////////// FOR UI ////////////////////////////
  ///////////////////// FOR UI ////////////////////////////
  ///////////////////// FOR UI ////////////////////////////
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

    addTestReview(
      testId: testId,
      rating: state.draftReviewRating,
      reviewText: state.draftReviewText.trim(),
    );

    if (state.draftReviewRating <= 0) {
      debugPrint("✗ rating is required");
      debugPrint("=================================================");
      return;
    }

    // لاحقًا هنا API نشر التقييم
    debugPrint("✓ ready to submit review");
    debugPrint("=================================================");
  }
  ////////////////////////////////////////////////////
  ////////////////////////////////////////////////////
  ////////////////////////////////////////////////////
  ////////////////////////////////////////////////////

  /////////////////////    OVERVIEW API //////////////////////////////
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

  /////////////////    SAMPLE API    ////////////////////
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

  ////////////////////  REVIEWS API ///////////////////////
  // Future<void> getOtherTestDetailsReviews({
  //   required int testId,
  //   String rating = 'all',
  //   int page = 1,
  // }) async {
  //   debugPrint(
  //     "============ DetailsOfTestCubit.getOtherTestDetailsReviews ============",
  //   );
  //   debugPrint("→ params: {testId: $testId, rating: $rating}");

  //   emit(
  //     state.copyWith(
  //       reviewsStatus: DetailsOfTestReviewsStatus.loading,
  //       selectedRatingFilter: rating,
  //       clearError: true,
  //     ),
  //   );

  //   final result = await getOtherTestDetailsReviewsUseCase(
  //     GetOtherTestDetailsReviewsParams(
  //       testId: testId,
  //       rating: rating,
  //       page: page,
  //     ),
  //   );

  //   result.fold(
  //     (failure) {
  //       debugPrint("✗ reviews failure title: ${failure.title}");
  //       debugPrint("✗ reviews failure message: ${failure.message}");

  //       emit(
  //         state.copyWith(
  //           reviewsStatus: DetailsOfTestReviewsStatus.failure,
  //           errorTitle: failure.title,
  //           errorMessage: failure.message,
  //         ),
  //       );
  //     },
  //     (response) {
  //       debugPrint("✓ reviews loaded successfully");
  //       debugPrint("→ average rating: ${response.data.summary.averageRating}");
  //       debugPrint("→ reviews count: ${response.data.reviews.length}");
  //       debugPrint("→ selected filter: $rating");

  //       emit(
  //         state.copyWith(
  //           reviewsStatus: DetailsOfTestReviewsStatus.success,
  //           reviewsDetails: response,
  //           selectedRatingFilter: rating,
  //           clearError: true,
  //         ),
  //       );
  //     },
  //   );

  //   debugPrint("=================================================");
  // }
  Future<void> getOtherTestDetailsReviews({
    required int testId,
    String rating = 'all',
    int page = 1,
    bool loadMore = false,
  }) async {
    debugPrint(
      "============ DetailsOfTestCubit.getOtherTestDetailsReviews ============",
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
          reviewsLoadMoreStatus: ReviewsLoadMoreStatus.loading,
          clearError: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          reviewsStatus: DetailsOfTestReviewsStatus.loading,
          reviewsLoadMoreStatus: ReviewsLoadMoreStatus.initial,
          selectedRatingFilter: rating,
          clearError: true,
        ),
      );
    }

    final result = await getOtherTestDetailsReviewsUseCase(
      GetOtherTestDetailsReviewsParams(
        testId: testId,
        rating: rating,
        page: page,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ reviews failure title: ${failure.title}");
        debugPrint("✗ reviews failure message: ${failure.message}");

        if (loadMore) {
          emit(
            state.copyWith(
              reviewsLoadMoreStatus: ReviewsLoadMoreStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              reviewsStatus: DetailsOfTestReviewsStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (response) {
        debugPrint("✓ reviews loaded successfully");
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
              myReview: response.data.myReview,
              reviews: mergedReviews,
              meta: response.data.meta,
            ),
          );

          emit(
            state.copyWith(
              reviewsStatus: DetailsOfTestReviewsStatus.success,
              reviewsLoadMoreStatus: ReviewsLoadMoreStatus.success,
              reviewsDetails: mergedResponse,
              selectedRatingFilter: rating,
              clearError: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            reviewsStatus: DetailsOfTestReviewsStatus.success,
            reviewsLoadMoreStatus: ReviewsLoadMoreStatus.initial,
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
    emit(
      state.copyWith(
        reviewsLoadMoreStatus: ReviewsLoadMoreStatus.initial,
        clearError: true,
      ),
    );
  }

  ////////////////////// LIKE API //////////////////////
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

  /////////////////////  BOOKMARK API ////////////////////
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

  /////////////////////////         FOLLOW API ////////////////////
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

  void resetLikeBookmarkFollowActionsState() {
    emit(
      state.copyWith(
        likeActionStatus: TestLikeActionStatus.initial,
        bookmarkActionStatus: TestBookmarkActionStatus.initial,
        followActionStatus: FollowActionStatus.initial,
        clearError: true,
      ),
    );
  }

  /////////////////////////////   DOWNLOAD API //////////////////
  Future<void> downloadTestFile({required int testId}) async {
    debugPrint("============ DetailsOfTestCubit.downloadTestFile ============");
    debugPrint("→ params: {testId: $testId}");

    if (state.isDownloadLoading) {
      debugPrint("✗ download already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        downloadStatus: DownloadTestFileStatus.loading,
        clearError: true,
      ),
    );

    final result = await downloadTestFileUseCase(
      DownloadTestFileParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ download failure title: ${failure.title}");
        debugPrint("✗ download failure message: ${failure.message}");

        emit(
          state.copyWith(
            downloadStatus: DownloadTestFileStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ download success");
        debugPrint("→ filePath: ${response.filePath}");
        debugPrint("→ fileName: ${response.fileName}");

        emit(
          state.copyWith(
            downloadStatus: DownloadTestFileStatus.success,
            downloadedFilePath: response.filePath,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  //////////////////    ADD REVIEW API ////////////////////
  Future<void> addTestReview({
    required int testId,
    required int rating,
    required String reviewText,
  }) async {
    debugPrint("============ DetailsOfTestCubit.addTestReview ============");
    debugPrint(
      "→ params: {testId: $testId, rating: $rating, reviewTextLength: ${reviewText.trim().length}}",
    );

    emit(state.copyWith(addReviewStatus: AddTestReviewStatus.loading));

    final result = await addTestReviewUseCase(
      AddTestReviewParams(
        testId: testId,
        rating: rating,
        reviewText: reviewText,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ addTestReview failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            addReviewStatus: AddTestReviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) async {
        debugPrint("✓ addTestReview success");
        debugPrint("→ message: ${response.message}");

        emit(state.copyWith(addReviewStatus: AddTestReviewStatus.success));

        debugPrint("→ refreshing reviews after add review");

        await getOtherTestDetailsReviews(
          testId: testId,
          rating: state.selectedRatingFilter,
        );

        debugPrint("=================================================");
      },
    );
  }

  void resetAddReviewState() {
    emit(state.copyWith(addReviewStatus: AddTestReviewStatus.initial));
  }

  ///////////////////// EDITING REVIEW API ////////////////////
  void startEditingMyReview({
    required int reviewId,
    required int rating,
    required String reviewText,
  }) {
    debugPrint(
      "============ DetailsOfTestCubit.startEditingMyReview ============",
    );
    debugPrint("→ reviewId: $reviewId");
    debugPrint("→ rating: $rating");
    debugPrint("→ reviewTextLength: ${reviewText.trim().length}");

    emit(
      state.copyWith(
        isEditingMyReview: true,
        editingReviewId: reviewId,
        draftReviewRating: rating,
        draftReviewText: reviewText,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }

  void cancelEditingMyReview() {
    debugPrint(
      "============ DetailsOfTestCubit.cancelEditingMyReview ============",
    );

    emit(
      state.copyWith(
        isEditingMyReview: false,
        clearEditingReviewId: true,
        draftReviewRating: 0,
        draftReviewText: '',
        updateReviewStatus: UpdateTestReviewStatus.initial,
        clearError: true,
      ),
    );

    debugPrint("=================================================");
  }

  Future<void> updateMyReview({required int testId}) async {
    debugPrint("============ DetailsOfTestCubit.updateMyReview ============");

    final rating = state.draftReviewRating;
    final reviewText = state.draftReviewText.trim();

    debugPrint(
      "→ params: {testId: $testId, rating: $rating, reviewTextLength: ${reviewText.length}}",
    );

    if (rating <= 0) {
      emit(
        state.copyWith(
          updateReviewStatus: UpdateTestReviewStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'اختر عدد النجوم أولًا',
        ),
      );
      return;
    }

    if (reviewText.isEmpty) {
      emit(
        state.copyWith(
          updateReviewStatus: UpdateTestReviewStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'اكتب تعليقك قبل النشر',
        ),
      );
      return;
    }

    if (state.isUpdateReviewLoading) {
      debugPrint("✗ update review already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        updateReviewStatus: UpdateTestReviewStatus.loading,
        clearError: true,
      ),
    );

    final result = await updateTestReviewUseCase(
      UpdateTestReviewParams(
        testId: testId,
        rating: rating,
        reviewText: reviewText,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ updateMyReview failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            updateReviewStatus: UpdateTestReviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) async {
        debugPrint("✓ updateMyReview success");
        debugPrint("→ message: ${response.message}");
        debugPrint("→ refreshing reviews after update");

        emit(
          state.copyWith(
            updateReviewStatus: UpdateTestReviewStatus.success,
            isEditingMyReview: false,
            clearEditingReviewId: true,
            draftReviewRating: 0,
            draftReviewText: '',
            clearError: true,
          ),
        );

        await getOtherTestDetailsReviews(
          testId: testId,
          rating: state.selectedRatingFilter,
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetUpdateReviewState() {
    emit(state.copyWith(updateReviewStatus: UpdateTestReviewStatus.initial));
  }

  ///////////////////  delete review API /////////////////
  Future<void> deleteMyReview({required int testId}) async {
    debugPrint("============ DetailsOfTestCubit.deleteMyReview ============");
    debugPrint("→ params: {testId: $testId}");

    if (state.isDeleteReviewLoading) {
      debugPrint("✗ delete review already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        deleteReviewStatus: DeleteTestReviewStatus.loading,
        clearError: true,
      ),
    );

    final result = await deleteTestReviewUseCase(
      DeleteTestReviewParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ deleteMyReview failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            deleteReviewStatus: DeleteTestReviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) async {
        debugPrint("✓ deleteMyReview success");
        debugPrint("→ message: ${response.message}");
        debugPrint("→ refreshing reviews after delete");

        emit(
          state.copyWith(
            deleteReviewStatus: DeleteTestReviewStatus.success,
            isEditingMyReview: false,
            clearEditingReviewId: true,
            draftReviewRating: 0,
            draftReviewText: '',
            clearError: true,
          ),
        );

        await getOtherTestDetailsReviews(
          testId: testId,
          rating: state.selectedRatingFilter,
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetDeleteReviewState() {
    emit(state.copyWith(deleteReviewStatus: DeleteTestReviewStatus.initial));
  }

  Future<void> toggleReviewFeedback({
    required int reviewId,
    required bool vote,
  }) async {
    debugPrint(
      "============ DetailsOfTestCubit.toggleReviewFeedback ============",
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
        reviewFeedbackStatus: ReviewFeedbackActionStatus.loading,
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
        debugPrint("✗ toggleReviewFeedback failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            reviewFeedbackStatus: ReviewFeedbackActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveFeedbackReviewId: true,
          ),
        );
      },
      (response) {
        debugPrint("✓ toggleReviewFeedback success");
        debugPrint("→ message: ${response.message}");

        final updatedReview = _buildUpdatedReviewAfterFeedback(
          review: review,
          requestedVote: requestedVote,
          shouldDelete: shouldDelete,
        );

        final updatedReviews = List<TestReviewEntity>.from(reviews);
        updatedReviews[reviewIndex] = updatedReview;

        final updatedReviewsDetails = reviewsDetails.copyWith(
          data: reviewsDetails.data.copyWith(reviews: updatedReviews),
        );

        emit(
          state.copyWith(
            reviewFeedbackStatus: ReviewFeedbackActionStatus.success,
            reviewsDetails: updatedReviewsDetails,
            clearError: true,
            clearActiveFeedbackReviewId: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetReviewFeedbackState() {
    emit(
      state.copyWith(
        reviewFeedbackStatus: ReviewFeedbackActionStatus.initial,
        clearActiveFeedbackReviewId: true,
        clearError: true,
      ),
    );
  }

  TestReviewEntity _buildUpdatedReviewAfterFeedback({
    required TestReviewEntity review,
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
        viewerFeedback: ReviewViewerFeedbackEntity(hasVoted: false, vote: null),
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
      viewerFeedback: ReviewViewerFeedbackEntity(
        hasVoted: true,
        vote: requestedVote,
      ),
    );
  }

  Future<void> submitReportCommentAndTest({
    required ReportTargetType targetType,
    required int targetId,
    required String reason,
    required String description,
  }) async {
    debugPrint("============ DetailsOfTestCubit.submitReport ============");
    debugPrint(
      "→ params: {targetType: ${targetType.name}, targetId: $targetId, reason: $reason, descriptionLength: ${description.trim().length}}",
    );

    if (state.isSubmitReportLoading) {
      debugPrint("✗ submit report already loading");
      debugPrint("=================================================");
      return;
    }

    final cleanDescription = description.trim();

    if (reason.trim().isEmpty) {
      emit(
        state.copyWith(
          submitReportStatus: SubmitReportStatus.failure,
          errorTitle: "تنبيه",
          errorMessage: "اختر سبب البلاغ أولًا",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitReportStatus: SubmitReportStatus.loading,
        clearError: true,
      ),
    );

    final result = await submitReportUseCase(
      SubmitReportParams(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
        description: cleanDescription,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ submitReport failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            submitReportStatus: SubmitReportStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ submitReport success");
        debugPrint("→ title: ${response.title}");
        debugPrint("→ message: ${response.message}");

        emit(
          state.copyWith(
            submitReportStatus: SubmitReportStatus.success,
            errorTitle: response.title,
            errorMessage: response.message,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetSubmitReportState() {
    emit(
      state.copyWith(
        submitReportStatus: SubmitReportStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> getTestShareLink({required int testId}) async {
    debugPrint("============ DetailsOfTestCubit.getTestShareLink ============");
    debugPrint("→ params: {testId: $testId}");

    if (state.isShareLinkLoading) {
      debugPrint("✗ share link already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        shareLinkStatus: TestShareLinkStatus.loading,
        clearShareUrl: true,
        clearError: true,
      ),
    );

    final result = await getTestShareLinkUseCase(
      GetTestShareLinkParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ getTestShareLink failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            shareLinkStatus: TestShareLinkStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearShareUrl: true,
          ),
        );
      },
      (response) {
        debugPrint("✓ getTestShareLink success");
        debugPrint("→ shareSlug: ${response.data.shareSlug}");
        debugPrint("→ shareUrl: ${response.data.shareUrl}");

        emit(
          state.copyWith(
            shareLinkStatus: TestShareLinkStatus.success,
            shareUrl: response.data.shareUrl,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetShareLinkState() {
    emit(
      state.copyWith(
        shareLinkStatus: TestShareLinkStatus.initial,
        clearShareUrl: true,
        clearError: true,
      ),
    );
  }

  Future<void> getSharedTestLink({required String slug}) async {
    debugPrint(
      "============ DetailsOfTestCubit.getSharedTestLink ============",
    );
    debugPrint("→ params: {slug: $slug}");

    if (state.isSharedTestLinkLoading) {
      debugPrint("✗ shared test link already loading");
      debugPrint("=================================================");
      return;
    }

    final cleanSlug = slug.trim();

    if (cleanSlug.isEmpty) {
      emit(
        state.copyWith(
          sharedTestLinkStatus: SharedTestLinkStatus.failure,
          errorTitle: "خطأ",
          errorMessage: "رابط الاختبار غير صالح",
          clearSharedTestLink: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        sharedTestLinkStatus: SharedTestLinkStatus.loading,
        clearSharedTestLink: true,
        clearError: true,
      ),
    );

    final result = await getSharedTestLinkUseCase(
      GetSharedTestLinkParams(slug: cleanSlug),
    );

    result.fold(
      (failure) {
        debugPrint("✗ getSharedTestLink failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            sharedTestLinkStatus: SharedTestLinkStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearSharedTestLink: true,
          ),
        );
      },
      (response) {
        debugPrint("✓ getSharedTestLink success");
        debugPrint("→ testId: ${response.data.testId}");
        debugPrint("→ isOwner: ${response.data.isOwner}");

        emit(
          state.copyWith(
            sharedTestLinkStatus: SharedTestLinkStatus.success,
            sharedTestId: response.data.testId,
            sharedTestIsOwner: response.data.isOwner,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetSharedTestLinkState() {
    emit(
      state.copyWith(
        sharedTestLinkStatus: SharedTestLinkStatus.initial,
        clearSharedTestLink: true,
        clearError: true,
      ),
    );
  }
}
