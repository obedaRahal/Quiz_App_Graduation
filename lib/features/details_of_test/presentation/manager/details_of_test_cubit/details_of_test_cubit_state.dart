import '../../../domain/entities/other_test_details_overview_entity.dart';

enum DetailsOfTestOverviewStatus {
  initial,
  loading,
  success,
  failure,
}

class DetailsOfTestState {
  final DetailsOfTestOverviewStatus overviewStatus;
  final OtherTestDetailsOverviewEntity? overviewDetails;

  final String? errorTitle;
  final String? errorMessage;

  const DetailsOfTestState({
    this.overviewStatus = DetailsOfTestOverviewStatus.initial,
    this.overviewDetails,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isOverviewLoading =>
      overviewStatus == DetailsOfTestOverviewStatus.loading;

  bool get isOverviewSuccess =>
      overviewStatus == DetailsOfTestOverviewStatus.success;

  bool get isOverviewFailure =>
      overviewStatus == DetailsOfTestOverviewStatus.failure;

  DetailsOfTestState copyWith({
    DetailsOfTestOverviewStatus? overviewStatus,
    OtherTestDetailsOverviewEntity? overviewDetails,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DetailsOfTestState(
      overviewStatus: overviewStatus ?? this.overviewStatus,
      overviewDetails: overviewDetails ?? this.overviewDetails,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}