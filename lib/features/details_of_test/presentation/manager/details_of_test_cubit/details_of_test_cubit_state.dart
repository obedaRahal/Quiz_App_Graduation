import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';

import '../../../domain/entities/other_test_details_overview_entity.dart';

enum DetailsOfTestOverviewStatus { initial, loading, success, failure }

enum DetailsOfTestSampleStatus { initial, loading, success, failure }

enum DetailsOfTestReviewsStatus { initial, loading, success, failure }

class DetailsOfTestState {
  final DetailsOfTestOverviewStatus overviewStatus;
  final OtherTestDetailsOverviewEntity? overviewDetails;

  final String? errorTitle;
  final String? errorMessage;

  final DetailsOfTestSampleStatus sampleStatus;
  final OtherTestDetailsSampleEntity? sampleDetails;

  final DetailsOfTestReviewsStatus reviewsStatus;
  final OtherTestDetailsReviewsEntity? reviewsDetails;
  final String selectedRatingFilter;

  const DetailsOfTestState({
    this.overviewStatus = DetailsOfTestOverviewStatus.initial,
    this.overviewDetails,
    this.errorTitle,
    this.errorMessage,
    this.sampleStatus = DetailsOfTestSampleStatus.initial,
    this.sampleDetails,

    this.reviewsStatus = DetailsOfTestReviewsStatus.initial,
    this.reviewsDetails,
    this.selectedRatingFilter = 'all',
  });

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

  DetailsOfTestState copyWith({
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
  }) {
    return DetailsOfTestState(
      overviewStatus: overviewStatus ?? this.overviewStatus,
      overviewDetails: overviewDetails ?? this.overviewDetails,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      sampleStatus: sampleStatus ?? this.sampleStatus,
      sampleDetails: sampleDetails ?? this.sampleDetails,

      reviewsStatus: reviewsStatus ?? this.reviewsStatus,
      reviewsDetails: reviewsDetails ?? this.reviewsDetails,
      selectedRatingFilter: selectedRatingFilter ?? this.selectedRatingFilter,
    );
  }
}
