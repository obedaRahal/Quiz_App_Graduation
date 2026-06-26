import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_params.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_search_params.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_tab_type.dart';
import 'package:quiz_app_grad/features/library/domain/usecases/get_library_content_usecase.dart';
import 'package:quiz_app_grad/features/library/domain/usecases/search_library_content_usecase.dart';

import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final GetLibraryContentUseCase getLibraryContentUseCase;
  final SearchLibraryContentUseCase searchLibraryContentUseCase;

  Timer? _searchDebounce;

  LibraryCubit({
    required this.getLibraryContentUseCase,
    required this.searchLibraryContentUseCase,
  }) : super(const LibraryState());

  Future<void> getInitialLibraryContent() async {
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
        LibraryParams(tab: state.selectedTab, perPage: 20),
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
    if (state.isSearchMode) return;

    final newTab = _tabFromIndex(index);

    if (newTab == state.selectedTab && state.status == LibraryStatus.success) {
      return;
    }

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

 void onSearchChanged(String value) {
  final query = value.trim();

  _searchDebounce?.cancel();

  if (query.isEmpty) {
    clearSearch();
    return;
  }

  if (query.length < 2) {
    emit(
      state.copyWith(
        isSearchMode: true,
        searchQuery: query,
        isSearching: false,
        searchMaterials: [],
        clearSearchNextCursor: true,
        searchHasMorePages: false,
        errorMessage: 'كلمة البحث قصيرة جدًا',
      ),
    );
    return;
  }

  emit(
    state.copyWith(
      isSearchMode: true,
      searchQuery: query,
      isSearching: true,
      searchMaterials: [],
      clearSearchNextCursor: true,
      searchHasMorePages: false,
      clearError: true,
    ),
  );

  _searchDebounce = Timer(const Duration(milliseconds: 600), () {
    _searchFirstPage(query);
  });
}

  Future<void> _searchFirstPage(String query) async {
    try {
      final response = await searchLibraryContentUseCase(
        LibrarySearchParams(
          query: query,
          perPage: 20,
        ),
      );

      if (state.searchQuery != query) return;

      emit(
        state.copyWith(
          isSearchMode: true,
          isSearching: false,
          searchMaterials: response.materials,
          searchNextCursor: response.meta.nextCursor,
          searchHasMorePages: response.meta.hasMorePages,
          clearError: true,
        ),
      );
    } catch (error) {
  emit(
    state.copyWith(
      isSearching: false,
      searchMaterials: [],
      clearSearchNextCursor: true,
      searchHasMorePages: false,
      errorMessage: error.toString(),
    ),
  );
}
  }

  void clearSearch() {
    _searchDebounce?.cancel();

    emit(
      state.copyWith(
        isSearchMode: false,
        searchQuery: '',
        searchMaterials: [],
        clearSearchNextCursor: true,
        searchHasMorePages: false,
        isSearching: false,
        isSearchLoadingMore: false,
        clearError: true,
      ),
    );
  }

  Future<void> loadMoreWhenNeeded(int index) async {
    if (state.isSearchMode) {
      await _loadMoreSearchWhenNeeded(index);
      return;
    }

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
          materials: [...state.materials, ...response.materials],
          nextCursor: response.meta.nextCursor,
          hasMorePages: response.meta.hasMorePages,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _loadMoreSearchWhenNeeded(int index) async {
    if (state.searchMaterials.isEmpty) return;
    if (!state.searchHasMorePages) return;
    if (state.searchNextCursor == null || state.searchNextCursor!.isEmpty) {
      return;
    }
    if (state.isSearchLoadingMore) return;
    if (state.isSearching) return;

    final triggerIndex = (state.searchMaterials.length * 0.5).floor();
    if (index < triggerIndex) return;

    await _loadMoreSearch();
  }

  Future<void> _loadMoreSearch() async {
    emit(state.copyWith(isSearchLoadingMore: true));

    try {
      final response = await searchLibraryContentUseCase(
        LibrarySearchParams(
          query: state.searchQuery,
          perPage: 20,
          cursor: state.searchNextCursor,
        ),
      );

      emit(
        state.copyWith(
          searchMaterials: [
            ...state.searchMaterials,
            ...response.materials,
          ],
          searchNextCursor: response.meta.nextCursor,
          searchHasMorePages: response.meta.hasMorePages,
          isSearchLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSearchLoadingMore: false,
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

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}