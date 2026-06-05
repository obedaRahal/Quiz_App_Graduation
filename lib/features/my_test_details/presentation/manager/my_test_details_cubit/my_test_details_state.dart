import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_status_history_entity.dart';

enum MyTestDetailsTab { overview, status, reviews }

enum MyPublicTestDetailsOverviewStatus { initial, loading, success, failure }

enum MyPublicTestStatusHistoryStatus { initial, loading, success, failure }

enum MyPublicTestReviewsStatus { initial, loading, success, failure }

enum MyPublicTestReviewsLoadMoreStatus { initial, loading, success, failure }

enum MyPublicReviewFeedbackActionStatus { initial, loading, success, failure }

enum MyPublicTestDownloadStatus { initial, loading, success, failure }

enum MyPublicTestShareLinkStatus { initial, loading, success, failure }

class MyTestDetailsState {
  final MyTestDetailsTab selectedTab;

  final Map<int, int> selectedSampleAnswers;

  final String selectedRatingFilter;

  final MyPublicTestDetailsOverviewStatus overviewStatus;
  final MyPublicTestDetailsOverviewEntity? overviewDetails;

  final MyPublicTestStatusHistoryStatus statusHistoryStatus;
  final MyPublicTestStatusHistoryEntity? statusHistoryDetails;

  final MyPublicTestReviewsStatus reviewsStatus;
  final MyPublicTestReviewsEntity? reviewsDetails;
  final MyPublicTestReviewsLoadMoreStatus reviewsLoadMoreStatus;

  final MyPublicReviewFeedbackActionStatus reviewFeedbackStatus;
  final int? activeFeedbackReviewId;

  final MyPublicTestDownloadStatus downloadStatus;
  final String? downloadedFilePath;

  final MyPublicTestShareLinkStatus shareLinkStatus;
  final String? shareUrl;

  final String? errorTitle;
  final String? errorMessage;

  const MyTestDetailsState({
    this.selectedTab = MyTestDetailsTab.overview,
    this.selectedSampleAnswers = const {},
    this.selectedRatingFilter = 'all',
    this.overviewStatus = MyPublicTestDetailsOverviewStatus.initial,
    this.overviewDetails,
    this.errorTitle,
    this.errorMessage,

    this.statusHistoryStatus = MyPublicTestStatusHistoryStatus.initial,
    this.statusHistoryDetails,

    this.reviewsStatus = MyPublicTestReviewsStatus.initial,
    this.reviewsDetails,
    this.reviewsLoadMoreStatus = MyPublicTestReviewsLoadMoreStatus.initial,

    this.reviewFeedbackStatus = MyPublicReviewFeedbackActionStatus.initial,
    this.activeFeedbackReviewId,

    this.downloadStatus = MyPublicTestDownloadStatus.initial,
    this.downloadedFilePath,

    this.shareLinkStatus = MyPublicTestShareLinkStatus.initial,
    this.shareUrl,
  });

  bool get isOverviewLoading =>
      overviewStatus == MyPublicTestDetailsOverviewStatus.loading;
  bool get isOverviewSuccess =>
      overviewStatus == MyPublicTestDetailsOverviewStatus.success;
  bool get isOverviewFailure =>
      overviewStatus == MyPublicTestDetailsOverviewStatus.failure;

  bool get isStatusHistoryLoading =>
      statusHistoryStatus == MyPublicTestStatusHistoryStatus.loading;
  bool get isStatusHistorySuccess =>
      statusHistoryStatus == MyPublicTestStatusHistoryStatus.success;
  bool get isStatusHistoryFailure =>
      statusHistoryStatus == MyPublicTestStatusHistoryStatus.failure;

  bool get isReviewsLoading =>
      reviewsStatus == MyPublicTestReviewsStatus.loading;
  bool get isReviewsSuccess =>
      reviewsStatus == MyPublicTestReviewsStatus.success;
  bool get isReviewsFailure =>
      reviewsStatus == MyPublicTestReviewsStatus.failure;
  bool get isInitialReviewsLoading =>
      reviewsStatus == MyPublicTestReviewsStatus.loading &&
      reviewsDetails == null;
  bool get isFilteringReviewsLoading =>
      reviewsStatus == MyPublicTestReviewsStatus.loading &&
      reviewsDetails != null;
  bool get isReviewsLoadMoreLoading =>
      reviewsLoadMoreStatus == MyPublicTestReviewsLoadMoreStatus.loading;
  bool get isReviewsLoadMoreSuccess =>
      reviewsLoadMoreStatus == MyPublicTestReviewsLoadMoreStatus.success;
  bool get isReviewsLoadMoreFailure =>
      reviewsLoadMoreStatus == MyPublicTestReviewsLoadMoreStatus.failure;

  bool get isReviewFeedbackLoading =>
      reviewFeedbackStatus == MyPublicReviewFeedbackActionStatus.loading;
  bool get isReviewFeedbackSuccess =>
      reviewFeedbackStatus == MyPublicReviewFeedbackActionStatus.success;
  bool get isReviewFeedbackFailure =>
      reviewFeedbackStatus == MyPublicReviewFeedbackActionStatus.failure;

  bool get isDownloadLoading =>
      downloadStatus == MyPublicTestDownloadStatus.loading;
  bool get isDownloadSuccess =>
      downloadStatus == MyPublicTestDownloadStatus.success;
  bool get isDownloadFailure =>
      downloadStatus == MyPublicTestDownloadStatus.failure;

  bool get isShareLinkLoading =>
      shareLinkStatus == MyPublicTestShareLinkStatus.loading;
  bool get isShareLinkSuccess =>
      shareLinkStatus == MyPublicTestShareLinkStatus.success;
  bool get isShareLinkFailure =>
      shareLinkStatus == MyPublicTestShareLinkStatus.failure;

  MyTestDetailsState copyWith({
    MyTestDetailsTab? selectedTab,
    Map<int, int>? selectedSampleAnswers,
    String? selectedRatingFilter,
    MyPublicTestDetailsOverviewStatus? overviewStatus,
    MyPublicTestDetailsOverviewEntity? overviewDetails,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    MyPublicTestStatusHistoryStatus? statusHistoryStatus,
    MyPublicTestStatusHistoryEntity? statusHistoryDetails,

    MyPublicTestReviewsStatus? reviewsStatus,
    MyPublicTestReviewsEntity? reviewsDetails,
    MyPublicTestReviewsLoadMoreStatus? reviewsLoadMoreStatus,

    MyPublicReviewFeedbackActionStatus? reviewFeedbackStatus,
    int? activeFeedbackReviewId,
    bool clearActiveFeedbackReviewId = false,

    MyPublicTestDownloadStatus? downloadStatus,
    String? downloadedFilePath,
    MyPublicTestShareLinkStatus? shareLinkStatus,
    String? shareUrl,
    bool clearShareUrl = false,
  }) {
    return MyTestDetailsState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedSampleAnswers:
          selectedSampleAnswers ?? this.selectedSampleAnswers,
      selectedRatingFilter: selectedRatingFilter ?? this.selectedRatingFilter,
      overviewStatus: overviewStatus ?? this.overviewStatus,
      overviewDetails: overviewDetails ?? this.overviewDetails,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      statusHistoryStatus: statusHistoryStatus ?? this.statusHistoryStatus,
      statusHistoryDetails: statusHistoryDetails ?? this.statusHistoryDetails,

      reviewsStatus: reviewsStatus ?? this.reviewsStatus,
      reviewsDetails: reviewsDetails ?? this.reviewsDetails,
      reviewsLoadMoreStatus:
          reviewsLoadMoreStatus ?? this.reviewsLoadMoreStatus,

      reviewFeedbackStatus: reviewFeedbackStatus ?? this.reviewFeedbackStatus,
      activeFeedbackReviewId: clearActiveFeedbackReviewId
          ? null
          : activeFeedbackReviewId ?? this.activeFeedbackReviewId,

      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      shareLinkStatus: shareLinkStatus ?? this.shareLinkStatus,
      shareUrl: clearShareUrl ? null : shareUrl ?? this.shareUrl,
    );
  }
}
