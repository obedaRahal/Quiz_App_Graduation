import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_details_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/report_other_content_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_material_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/bookmark_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/download_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/follow_publisher_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/get_other_content_details_usecase.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/get_similar_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/like_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/my_content_details/delete_my_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/my_content_details/get_my_public_content_details_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/report_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unbookmark_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unfollow_publisher_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unlike_other_content_use_case.dart';

import 'other_content_details_state.dart';

class OtherContentDetailsCubit extends Cubit<OtherContentDetailsState> {
  final GetOtherContentDetailsUseCase getOtherContentDetailsUseCase;
  final LikeOtherContentUseCase likeOtherContentUseCase;
  final UnlikeOtherContentUseCase unlikeOtherContentUseCase;
  final BookmarkOtherContentUseCase bookmarkOtherContentUseCase;
  final UnbookmarkOtherContentUseCase unbookmarkOtherContentUseCase;
  final ReportOtherContentUseCase reportOtherContentUseCase;
  final DownloadOtherContentUseCase downloadOtherContentUseCase;
  final GetSimilarContentUseCase getSimilarContentUseCase;
  final FollowPublisherUseCase followPublisherUseCase;
  final UnfollowPublisherUseCase unfollowPublisherUseCase;
  final GetMyPublicContentDetailsUseCase getMyPublicContentDetailsUseCase;
  final DeleteMyContentUseCase deleteMyContentUseCase;
  OtherContentDetailsCubit({
    required this.getOtherContentDetailsUseCase,
    required this.likeOtherContentUseCase,
    required this.unlikeOtherContentUseCase,
    required this.bookmarkOtherContentUseCase,
    required this.unbookmarkOtherContentUseCase,
    required this.reportOtherContentUseCase,
    required this.downloadOtherContentUseCase,
    required this.getSimilarContentUseCase,
    required this.followPublisherUseCase,
    required this.unfollowPublisherUseCase,
    required this.getMyPublicContentDetailsUseCase,
    required this.deleteMyContentUseCase,
  }) : super(const OtherContentDetailsState());

  Future<void> getContentDetails(int id) async {
    debugPrint('=========== OtherContentDetailsCubit ===========');

    emit(
      state.copyWith(
        status: OtherContentDetailsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final response = await getOtherContentDetailsUseCase(
        OtherContentDetailsParams(contentId: id),
      );

      emit(
        state.copyWith(
          status: OtherContentDetailsStatus.success,
          details: response,
          viewerHasLiked: response.viewerState.viewerHasLiked,
          likeCount: response.basicInfo.likeCount,
          viewerHasBookmarked: response.viewerState.viewerHasBookmarked,
          bookmarksCount: response.basicInfo.bookmarksCount,
          viewerIsFollowingPublisher:
              response.viewerState.viewerIsFollowingCreator,
        ),
      );
      await getInitialSimilarContent();
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: OtherContentDetailsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getInitialSimilarContent() async {
    final details = state.details;
    if (details == null) return;

    final interestIds = details.basicInfo.interests
        .map((interest) => interest.id)
        .take(3)
        .toList();
    debugPrint('Similar interest ids from details: $interestIds');
    if (interestIds.isEmpty) return;

    emit(
      state.copyWith(
        isSimilarLoading: true,
        isSimilarLoadingMore: false,
        similarMaterials: [],
        clearSimilarNextCursor: true,
        similarHasMorePages: false,
        clearError: true,
      ),
    );

    try {
      final response = await getSimilarContentUseCase(
        SimilarContentParams(
          contentId: details.basicInfo.id,
          interestIds: interestIds,
          perPage: 20,
        ),
      );

      emit(
        state.copyWith(
          isSimilarLoading: false,
          similarMaterials: response.materials,
          similarNextCursor: response.meta.nextCursor,
          similarHasMorePages: response.meta.hasMorePages,
        ),
      );
    } catch (e) {
      debugPrint('getInitialSimilarContent error: $e');

      emit(state.copyWith(isSimilarLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadMoreSimilarWhenNeeded(int index) async {
    if (state.similarMaterials.isEmpty) return;
    if (!state.similarHasMorePages) return;
    if (state.similarNextCursor == null || state.similarNextCursor!.isEmpty) {
      return;
    }
    if (state.isSimilarLoadingMore) return;

    final triggerIndex = (state.similarMaterials.length * 0.5).floor();

    if (index < triggerIndex) return;

    await _loadMoreSimilarContent();
  }

  Future<void> _loadMoreSimilarContent() async {
    final details = state.details;
    if (details == null) return;

    final interestIds = details.basicInfo.interests
        .map((interest) => interest.id)
        .take(3)
        .toList();

    if (interestIds.isEmpty) return;

    emit(state.copyWith(isSimilarLoadingMore: true, clearError: true));

    try {
      final response = await getSimilarContentUseCase(
        SimilarContentParams(
          contentId: details.basicInfo.id,
          interestIds: interestIds,
          perPage: 20,
          cursor: state.similarNextCursor,
        ),
      );

      emit(
        state.copyWith(
          isSimilarLoadingMore: false,
          similarMaterials: [...state.similarMaterials, ...response.materials],
          similarNextCursor: response.meta.nextCursor,
          similarHasMorePages: response.meta.hasMorePages,
        ),
      );
    } catch (e) {
      debugPrint('loadMoreSimilarContent error: $e');

      emit(
        state.copyWith(isSimilarLoadingMore: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> toggleLike() async {
    final details = state.details;
    if (details == null || state.isLikeLoading) return;

    final oldLiked = state.viewerHasLiked ?? details.viewerState.viewerHasLiked;
    final oldCount = state.likeCount ?? details.basicInfo.likeCount;

    final newLiked = !oldLiked;
    final newCount = newLiked
        ? oldCount + 1
        : (oldCount - 1).clamp(0, oldCount);

    emit(
      state.copyWith(
        viewerHasLiked: newLiked,
        likeCount: newCount,
        isLikeLoading: true,
        clearError: true,
      ),
    );

    try {
      if (newLiked) {
        await likeOtherContentUseCase(details.basicInfo.id);
      } else {
        await unlikeOtherContentUseCase(details.basicInfo.id);
      }

      emit(state.copyWith(isLikeLoading: false));
    } catch (e) {
      debugPrint('toggleLike error: $e');
      emit(
        state.copyWith(
          viewerHasLiked: oldLiked,
          likeCount: oldCount,
          isLikeLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> toggleBookmark() async {
    final details = state.details;
    if (details == null || state.isBookmarkLoading) return;

    final oldBookmarked =
        state.viewerHasBookmarked ?? details.viewerState.viewerHasBookmarked;
    final oldCount = state.bookmarksCount ?? details.basicInfo.bookmarksCount;

    final newBookmarked = !oldBookmarked;
    final newCount = newBookmarked
        ? oldCount + 1
        : (oldCount - 1).clamp(0, oldCount);

    emit(
      state.copyWith(
        viewerHasBookmarked: newBookmarked,
        bookmarksCount: newCount,
        isBookmarkLoading: true,
        clearError: true,
      ),
    );

    try {
      if (newBookmarked) {
        await bookmarkOtherContentUseCase(details.basicInfo.id);
      } else {
        await unbookmarkOtherContentUseCase(details.basicInfo.id);
      }

      emit(state.copyWith(isBookmarkLoading: false));
    } catch (e) {
      debugPrint('toggleBookmark error: $e');
      emit(
        state.copyWith(
          viewerHasBookmarked: oldBookmarked,
          bookmarksCount: oldCount,
          isBookmarkLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> reportContent({
    required String reason,
    String? description,
  }) async {
    final details = state.details;
    if (details == null) return;
    if (state.isReportLoading) return;

    emit(state.copyWith(isReportLoading: true, clearError: true));

    try {
      final response = await reportOtherContentUseCase(
        ReportOtherContentParams(
          contentId: details.basicInfo.id,
          reason: reason,
          description: description,
        ),
      );

      emit(
        state.copyWith(
          isReportLoading: false,
          hasReported: true,
          successMessage: response.title,
        ),
      );

      debugPrint(response.title);
    } catch (e) {
      debugPrint('reportContent error: $e');

      emit(state.copyWith(isReportLoading: false, errorMessage: e.toString()));
    }
  }

  void clearSuccessMessage() {
    emit(state.copyWith(clearSuccess: true));
  }

 Future<void> downloadContent() async {
  final contentId =
      state.details?.basicInfo.id ?? state.myDetails?.basicInfo.id;

  debugPrint('=========== downloadContent ===========');
  debugPrint('contentId: $contentId');

  if (contentId == null) return;
  if (state.isDownloadLoading) return;

  emit(
    state.copyWith(
      isDownloadLoading: true,
      clearError: true,
      clearSuccess: true,
    ),
  );

  try {
   
final filePath = await downloadOtherContentUseCase(contentId);
   emit(
  state.copyWith(
    isDownloadLoading: false,
    successMessage: 'تم تحميل المحتوى بنجاح',
    showOpenDownloadedFileDialog: true,
    downloadedFilePath: filePath,
  ),
);
  } catch (e) {
    debugPrint('downloadContent error: $e');

    emit(
      state.copyWith(
        isDownloadLoading: false,
        errorMessage: e.toString(),
      ),
    );
  }
}
  void clearDownloadDialog() {
  emit(
    state.copyWith(
      showOpenDownloadedFileDialog: false,
      clearSuccess: true,
      clearDownloadedFilePath: true,
    ),
  );
}

  Future<void> toggleSimilarBookmark(int contentId) async {
    if (state.similarBookmarkLoadingIds.contains(contentId)) return;

    final index = state.similarMaterials.indexWhere(
      (item) => item.id == contentId,
    );

    if (index == -1) return;

    final oldItem = state.similarMaterials[index];
    final oldBookmarked = oldItem.viewerHasBookmarked;
    final newBookmarked = !oldBookmarked;

    final loadingIds = {...state.similarBookmarkLoadingIds, contentId};

    final updatedMaterials = [...state.similarMaterials];
    updatedMaterials[index] = SimilarContentMaterialEntity(
      id: oldItem.id,
      urlContent: oldItem.urlContent,
      title: oldItem.title,
      description: oldItem.description,
      type: oldItem.type,
      interests: oldItem.interests,
      likeCount: oldItem.likeCount,
      publishedAt: oldItem.publishedAt,
      viewerHasBookmarked: newBookmarked,
    );

    emit(
      state.copyWith(
        similarMaterials: updatedMaterials,
        similarBookmarkLoadingIds: loadingIds,
        clearError: true,
      ),
    );

    try {
      if (newBookmarked) {
        await bookmarkOtherContentUseCase(contentId);
      } else {
        await unbookmarkOtherContentUseCase(contentId);
      }

      final newLoadingIds = {...state.similarBookmarkLoadingIds}
        ..remove(contentId);

      emit(state.copyWith(similarBookmarkLoadingIds: newLoadingIds));
    } catch (e) {
      debugPrint('toggleSimilarBookmark error: $e');

      final rollbackMaterials = [...state.similarMaterials];
      final rollbackIndex = rollbackMaterials.indexWhere(
        (item) => item.id == contentId,
      );

      if (rollbackIndex != -1) {
        final currentItem = rollbackMaterials[rollbackIndex];

        rollbackMaterials[rollbackIndex] = SimilarContentMaterialEntity(
          id: currentItem.id,
          urlContent: currentItem.urlContent,
          title: currentItem.title,
          description: currentItem.description,
          type: currentItem.type,
          interests: currentItem.interests,
          likeCount: currentItem.likeCount,
          publishedAt: currentItem.publishedAt,
          viewerHasBookmarked: oldBookmarked,
        );
      }

      final newLoadingIds = {...state.similarBookmarkLoadingIds}
        ..remove(contentId);

      emit(
        state.copyWith(
          similarMaterials: rollbackMaterials,
          similarBookmarkLoadingIds: newLoadingIds,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> followPublisher() async {
    final details = state.details;
    if (details == null) return;
    if (details.publisher == null) return;
    if (state.isFollowLoading) return;

    emit(state.copyWith(isFollowLoading: true, clearError: true));

    try {
      final response = await followPublisherUseCase(details.publisher!.id);

      emit(
        state.copyWith(
          isFollowLoading: false,
          viewerIsFollowingPublisher: true,
        ),
      );
    } catch (e) {
      debugPrint('followPublisher error: $e');

      emit(state.copyWith(isFollowLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> unfollowPublisher() async {
    final details = state.details;
    if (details == null) return;
    if (details.publisher == null) return;
    if (state.isUnfollowLoading || state.isFollowLoading) return;

    emit(state.copyWith(isUnfollowLoading: true, clearError: true));

    try {
      await unfollowPublisherUseCase(details.publisher!.id);

      emit(
        state.copyWith(
          isUnfollowLoading: false,
          viewerIsFollowingPublisher: false,
        ),
      );
    } catch (e) {
      debugPrint('unfollowPublisher error: $e');

      emit(
        state.copyWith(isUnfollowLoading: false, errorMessage: e.toString()),
      );
    }
  }
  //            My Content Details
  Future<void> getMyContentDetails(int id) async {
  debugPrint('=========== MyContentDetailsCubit Method ===========');

  emit(
    state.copyWith(
      status: OtherContentDetailsStatus.loading,
      clearError: true,
      clearMyDetails: true,
    ),
  );

  try {
    final response = await getMyPublicContentDetailsUseCase(
      MyContentDetailsParams(contentId: id),
    );

    emit(
      state.copyWith(
        status: OtherContentDetailsStatus.success,
        myDetails: response,
        clearError: true,
      ),
    );
  } catch (e) {
    debugPrint('getMyContentDetails error: $e');

    emit(
      state.copyWith(
        status: OtherContentDetailsStatus.failure,
        errorMessage: e.toString(),
      ),
    );
  }
}
// Delete Content
Future<void> deleteMyContent() async {
  final contentId =
      state.myDetails?.basicInfo.id ?? state.details?.basicInfo.id;

  if (contentId == null) return;
  if (state.isDeleteLoading) return;

  debugPrint('=========== deleteMyContent ===========');
  debugPrint('contentId: $contentId');

  emit(
    state.copyWith(
      isDeleteLoading: true,
      clearError: true,
      clearSuccess: true,
    ),
  );

  try {
    final response = await deleteMyContentUseCase(contentId);

    emit(
      state.copyWith(
        isDeleteLoading: false,
        isDeleted: true,
        successMessage: response.message,
      ),
    );
  } catch (e) {
    debugPrint('deleteMyContent error: $e');

    emit(
      state.copyWith(
        isDeleteLoading: false,
        errorMessage: e.toString(),
      ),
    );
  }
}
}
