import 'package:quiz_app_grad/features/library/domain/entities/library_featured_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_material_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_tab_type.dart';

enum LibraryStatus {
  initial,
  loading,
  success,
  failure,
}

class LibraryState {
  final LibraryStatus status;
  final LibraryTabType selectedTab;
  final List<LibraryFeaturedEntity> featured;
  final List<LibraryMaterialEntity> materials;
  final String? nextCursor;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? errorMessage;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.selectedTab = LibraryTabType.trending,
    this.featured = const [],
    this.materials = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.isLoadingMore = false,
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

  LibraryState copyWith({
    LibraryStatus? status,
    LibraryTabType? selectedTab,
    List<LibraryFeaturedEntity>? featured,
    List<LibraryMaterialEntity>? materials,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMorePages,
    bool? isLoadingMore,
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
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}