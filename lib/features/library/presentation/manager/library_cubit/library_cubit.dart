import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_params.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_tab_type.dart';
import 'package:quiz_app_grad/features/library/domain/usecases/get_library_content_usecase.dart';

import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final GetLibraryContentUseCase getLibraryContentUseCase;

  LibraryCubit({
    required this.getLibraryContentUseCase,
  }) : super(const LibraryState());

  Future<void> getInitialLibraryContent() async {
    debugPrint('================ LibraryCubit getInitialLibraryContent ================');

    emit(
      state.copyWith(
        status: LibraryStatus.loading,
        featured: [],
        materials: [],
        clearNextCursor: true,
        hasMorePages: false,
        isLoadingMore: false,
        clearError: true,
      ),
    );

    try {
      final response = await getLibraryContentUseCase(
        LibraryParams(
          tab: state.selectedTab,
          perPage: 20,
        ),
      );

      emit(
        state.copyWith(
          status: LibraryStatus.success,
          featured: response.featured,
          materials: response.materials,
          nextCursor: response.meta.nextCursor,
          hasMorePages: response.meta.hasMorePages,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      debugPrint('LibraryCubit initial error: $error');

      emit(
        state.copyWith(
          status: LibraryStatus.failure,
          errorMessage: error.toString(),
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> changeTabByIndex(int index) async {
    final newTab = _tabFromIndex(index);

    if (newTab == state.selectedTab && state.status == LibraryStatus.success) {
      return;
    }

    debugPrint('================ LibraryCubit changeTab ================');
    debugPrint('new tab: ${newTab.apiValue}');

    emit(
      state.copyWith(
        selectedTab: newTab,
        status: LibraryStatus.loading,
        featured: [],
        materials: [],
        clearNextCursor: true,
        hasMorePages: false,
        isLoadingMore: false,
        clearError: true,
      ),
    );

    await getInitialLibraryContent();
  }

  Future<void> loadMoreWhenNeeded(int index) async {
    if (state.materials.isEmpty) return;
    if (!state.hasMorePages) return;
    if (state.nextCursor == null || state.nextCursor!.isEmpty) return;
    if (state.isLoadingMore) return;
    if (state.status != LibraryStatus.success) return;

    final triggerIndex = (state.materials.length * 0.5).floor();

    if (index < triggerIndex) return;

    await _loadMore();
  }

  Future<void> _loadMore() async {
    debugPrint('================ LibraryCubit loadMore ================');
    debugPrint('cursor: ${state.nextCursor}');

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await getLibraryContentUseCase(
        LibraryParams(
          tab: state.selectedTab,
          perPage: 20,
          cursor: state.nextCursor,
        ),
      );

      emit(
        state.copyWith(
          status: LibraryStatus.success,
          featured: state.featured,
          materials: [
            ...state.materials,
            ...response.materials,
          ],
          nextCursor: response.meta.nextCursor,
          hasMorePages: response.meta.hasMorePages,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      debugPrint('LibraryCubit loadMore error: $error');

      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  LibraryTabType _tabFromIndex(int index) {
    switch (index) {
      case 1:
        return LibraryTabType.newest;
      case 2:
        return LibraryTabType.mostDownloaded;
      case 0:
      default:
        return LibraryTabType.trending;
    }
  }
}