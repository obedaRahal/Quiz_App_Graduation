import 'package:quiz_app_grad/features/library/domain/entities/library_featured_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_material_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_tab_type.dart';

enum LibraryStatus { initial, loading, success, failure }

class LibraryState {
  final LibraryStatus status;
  final LibraryTabType selectedTab;

  final List<LibraryFeaturedEntity> featured;
  final List<LibraryMaterialEntity> materials;
  final String? nextCursor;
  final bool hasMorePages;
  final bool isLoadingMore;

  final bool isSearchMode;
  final String searchQuery;
  final List<LibraryMaterialEntity> searchMaterials;
  final String? searchNextCursor;
  final bool searchHasMorePages;
  final bool isSearching;
  final bool isSearchLoadingMore;

  final String? errorMessage;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.selectedTab = LibraryTabType.trending,
    this.featured = const [],
    this.materials = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.isLoadingMore = false,
    this.isSearchMode = false,
    this.searchQuery = '',
    this.searchMaterials = const [],
    this.searchNextCursor,
    this.searchHasMorePages = false,
    this.isSearching = false,
    this.isSearchLoadingMore = false,
    this.errorMessage,
  });

  int get selectedTabIndex {
    switch (selectedTab) {
      case LibraryTabType.trending:
        return 0;
      case LibraryTabType.newest:
        return 1;
      case LibraryTabType.mostDownloaded:
        return 2;
    }
  }

  List<LibraryMaterialEntity> get displayedMaterials {
    return isSearchMode ? searchMaterials : materials;
  }

  LibraryState copyWith({
    LibraryStatus? status,
    LibraryTabType? selectedTab,
    List<LibraryFeaturedEntity>? featured,
    List<LibraryMaterialEntity>? materials,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMorePages,
    bool? isLoadingMore,
    bool? isSearchMode,
    String? searchQuery,
    List<LibraryMaterialEntity>? searchMaterials,
    String? searchNextCursor,
    bool clearSearchNextCursor = false,
    bool? searchHasMorePages,
    bool? isSearching,
    bool? isSearchLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LibraryState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      featured: featured ?? this.featured,
      materials: materials ?? this.materials,
      nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      searchQuery: searchQuery ?? this.searchQuery,
      searchMaterials: searchMaterials ?? this.searchMaterials,
      searchNextCursor: clearSearchNextCursor
          ? null
          : searchNextCursor ?? this.searchNextCursor,
      searchHasMorePages: searchHasMorePages ?? this.searchHasMorePages,
      isSearching: isSearching ?? this.isSearching,
      isSearchLoadingMore: isSearchLoadingMore ?? this.isSearchLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}