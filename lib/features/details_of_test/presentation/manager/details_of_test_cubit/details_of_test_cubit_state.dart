import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';

import '../../../domain/entities/other_test_details_overview_entity.dart';

enum DetailsOfTestTab { overview, sample, reviews }

enum DetailsOfTestOverviewStatus { initial, loading, success, failure }

enum DetailsOfTestSampleStatus { initial, loading, success, failure }

enum DetailsOfTestReviewsStatus { initial, loading, success, failure }

enum TestLikeActionStatus { initial, loading, success, failure }

enum TestBookmarkActionStatus { initial, loading, success, failure }

enum FollowActionStatus { initial, loading, success, failure }

class DetailsOfTestState {
  //  for UI ////
  final DetailsOfTestTab selectedTab;
  final Map<int, int> selectedSampleAnswers;
  final int draftReviewRating;
  final String draftReviewText;
  ///////////////

  final DetailsOfTestOverviewStatus overviewStatus;
  final OtherTestDetailsOverviewEntity? overviewDetails;

  final String? errorTitle;
  final String? errorMessage;

  final DetailsOfTestSampleStatus sampleStatus;
  final OtherTestDetailsSampleEntity? sampleDetails;

  final DetailsOfTestReviewsStatus reviewsStatus;
  final OtherTestDetailsReviewsEntity? reviewsDetails;
  final String selectedRatingFilter;

  final TestLikeActionStatus likeActionStatus;
  final TestBookmarkActionStatus bookmarkActionStatus;

  final FollowActionStatus followActionStatus;

  const DetailsOfTestState({
    this.selectedTab = DetailsOfTestTab.overview,
    this.selectedSampleAnswers = const {},
    this.draftReviewRating = 0,
    this.draftReviewText = '',

    this.overviewStatus = DetailsOfTestOverviewStatus.initial,
    this.overviewDetails,
    this.errorTitle,
    this.errorMessage,
    this.sampleStatus = DetailsOfTestSampleStatus.initial,
    this.sampleDetails,

    this.reviewsStatus = DetailsOfTestReviewsStatus.initial,
    this.reviewsDetails,
    this.selectedRatingFilter = 'all',

    this.likeActionStatus = TestLikeActionStatus.initial,
    this.bookmarkActionStatus = TestBookmarkActionStatus.initial,

    this.followActionStatus = FollowActionStatus.initial,
  });

  bool get canSubmitDraftReview => draftReviewRating > 0;

  bool get isOverviewLoading =>
      overviewStatus == DetailsOfTestOverviewStatus.loading;

  bool get isOverviewSuccess =>
      overviewStatus == DetailsOfTestOverviewStatus.success;

  bool get isOverviewFailure =>
      overviewStatus == DetailsOfTestOverviewStatus.failure;

  bool get isSampleLoading => sampleStatus == DetailsOfTestSampleStatus.loading;

  bool get isSampleSuccess => sampleStatus == DetailsOfTestSampleStatus.success;

  bool get isSampleFailure => sampleStatus == DetailsOfTestSampleStatus.failure;

  bool get isReviewsLoading =>
      reviewsStatus == DetailsOfTestReviewsStatus.loading;

  bool get isReviewsSuccess =>
      reviewsStatus == DetailsOfTestReviewsStatus.success;

  bool get isReviewsFailure =>
      reviewsStatus == DetailsOfTestReviewsStatus.failure;

  bool get isLikeActionLoading =>
      likeActionStatus == TestLikeActionStatus.loading;

  bool get isBookmarkActionLoading =>
      bookmarkActionStatus == TestBookmarkActionStatus.loading;

  bool get isFollowActionLoading =>
      followActionStatus == FollowActionStatus.loading;

  DetailsOfTestState copyWith({
    //  for UI ////
    DetailsOfTestTab? selectedTab,
    Map<int, int>? selectedSampleAnswers,
    int? draftReviewRating,
    String? draftReviewText,

    DetailsOfTestOverviewStatus? overviewStatus,
    OtherTestDetailsOverviewEntity? overviewDetails,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    DetailsOfTestSampleStatus? sampleStatus,
    OtherTestDetailsSampleEntity? sampleDetails,

    DetailsOfTestReviewsStatus? reviewsStatus,
    OtherTestDetailsReviewsEntity? reviewsDetails,
    String? selectedRatingFilter,

    TestLikeActionStatus? likeActionStatus,
    TestBookmarkActionStatus? bookmarkActionStatus,

    FollowActionStatus? followActionStatus,
  }) {
    return DetailsOfTestState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedSampleAnswers:
          selectedSampleAnswers ?? this.selectedSampleAnswers,
      draftReviewRating: draftReviewRating ?? this.draftReviewRating,
      draftReviewText: draftReviewText ?? this.draftReviewText,

      overviewStatus: overviewStatus ?? this.overviewStatus,
      overviewDetails: overviewDetails ?? this.overviewDetails,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      sampleStatus: sampleStatus ?? this.sampleStatus,
      sampleDetails: sampleDetails ?? this.sampleDetails,

      reviewsStatus: reviewsStatus ?? this.reviewsStatus,
      reviewsDetails: reviewsDetails ?? this.reviewsDetails,
      selectedRatingFilter: selectedRatingFilter ?? this.selectedRatingFilter,

      likeActionStatus: likeActionStatus ?? this.likeActionStatus,
      bookmarkActionStatus: bookmarkActionStatus ?? this.bookmarkActionStatus,

      followActionStatus: followActionStatus ?? this.followActionStatus,
    );
  }
}
