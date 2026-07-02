import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_details_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_material_entity.dart';

enum OtherContentDetailsStatus { initial, loading, success, failure }

class OtherContentDetailsState {
  final OtherContentDetailsStatus status;
  final OtherContentDetailsEntity? details;
  final String? errorMessage;

  final bool isLikeLoading;
  final bool? viewerHasLiked;
  final int? likeCount;

  final bool isBookmarkLoading;
  final bool? viewerHasBookmarked;
  final int? bookmarksCount;
  final bool isReportLoading;
  final bool hasReported;
  final String? successMessage;
  final bool isDownloadLoading;
  final bool showOpenDownloadedFileDialog;
  final bool isSimilarLoading;
  final bool isSimilarLoadingMore;
  final List<SimilarContentMaterialEntity> similarMaterials;
  final String? similarNextCursor;
  final bool similarHasMorePages;
  final Set<int> similarBookmarkLoadingIds;
  final bool isFollowLoading;
final bool? viewerIsFollowingPublisher;
final bool isUnfollowLoading;

  const OtherContentDetailsState({
    this.status = OtherContentDetailsStatus.initial,
    this.details,
    this.errorMessage,
    this.isLikeLoading = false,
    this.viewerHasLiked,
    this.likeCount,
    this.isBookmarkLoading = false,
    this.viewerHasBookmarked,
    this.bookmarksCount,
    this.isReportLoading = false,
    this.hasReported = false,
    this.successMessage,
    this.isDownloadLoading = false,
    this.showOpenDownloadedFileDialog = false,
    this.isSimilarLoading = false,
    this.isSimilarLoadingMore = false,
    this.similarMaterials = const [],
    this.similarNextCursor,
    this.similarHasMorePages = false,
    this.similarBookmarkLoadingIds = const {},
    this.isFollowLoading = false,
this.viewerIsFollowingPublisher,
this.isUnfollowLoading = false,
  });

  OtherContentDetailsState copyWith({
    OtherContentDetailsStatus? status,
    OtherContentDetailsEntity? details,
    String? errorMessage,
    bool clearError = false,
    bool? isLikeLoading,
    bool? viewerHasLiked,
    int? likeCount,
    bool? isBookmarkLoading,
    bool? viewerHasBookmarked,
    int? bookmarksCount,
    bool? isReportLoading,
    bool? hasReported,
    String? successMessage,
    bool clearSuccess = false,
    bool? isDownloadLoading,
    bool? showOpenDownloadedFileDialog,
    bool? isSimilarLoading,
    bool? isSimilarLoadingMore,
    List<SimilarContentMaterialEntity>? similarMaterials,
    String? similarNextCursor,
    bool clearSimilarNextCursor = false,
    bool? similarHasMorePages,
    Set<int>? similarBookmarkLoadingIds,
    bool? isFollowLoading,
bool? viewerIsFollowingPublisher,
bool? isUnfollowLoading,
  }) {
    return OtherContentDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLikeLoading: isLikeLoading ?? this.isLikeLoading,
      viewerHasLiked: viewerHasLiked ?? this.viewerHasLiked,
      likeCount: likeCount ?? this.likeCount,
      isBookmarkLoading: isBookmarkLoading ?? this.isBookmarkLoading,
      viewerHasBookmarked: viewerHasBookmarked ?? this.viewerHasBookmarked,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isReportLoading: isReportLoading ?? this.isReportLoading,
      hasReported: hasReported ?? this.hasReported,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      isDownloadLoading: isDownloadLoading ?? this.isDownloadLoading,
      showOpenDownloadedFileDialog:
          showOpenDownloadedFileDialog ?? this.showOpenDownloadedFileDialog,
      isSimilarLoading: isSimilarLoading ?? this.isSimilarLoading,
      isSimilarLoadingMore: isSimilarLoadingMore ?? this.isSimilarLoadingMore,
      similarMaterials: similarMaterials ?? this.similarMaterials,
      similarNextCursor: clearSimilarNextCursor
          ? null
          : similarNextCursor ?? this.similarNextCursor,
      similarHasMorePages: similarHasMorePages ?? this.similarHasMorePages,
      similarBookmarkLoadingIds:
          similarBookmarkLoadingIds ?? this.similarBookmarkLoadingIds,
          isFollowLoading: isFollowLoading ?? this.isFollowLoading,
viewerIsFollowingPublisher:
    viewerIsFollowingPublisher ?? this.viewerIsFollowingPublisher,
    isUnfollowLoading: isUnfollowLoading ?? this.isUnfollowLoading,
    );
  }
}
