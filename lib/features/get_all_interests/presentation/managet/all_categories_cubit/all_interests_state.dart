import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';

class AllInterestsState {
  final bool isLoading;
  final String? errorMessage;
  final List<InterestCategoryEntity> categories;
  final String searchText;

  const AllInterestsState({
    this.isLoading = false,
    this.errorMessage,
    this.categories = const [],
    this.searchText = '',
  });

  List<InterestCategoryEntity> get filteredCategories {
    if (searchText.trim().isEmpty) return categories;

    return categories
        .map((category) {
          final filteredInterests = category.interests.where((interest) {
            return interest.name.contains(searchText.trim()) ||
                category.title.contains(searchText.trim());
          }).toList();

          return InterestCategoryEntity(
            id: category.id,
            title: category.title,
            interests: filteredInterests,
          );
        })
        .where((category) => category.interests.isNotEmpty)
        .toList();
  }

  AllInterestsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<InterestCategoryEntity>? categories,
    String? searchText,
  }) {
    return AllInterestsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      categories: categories ?? this.categories,
      searchText: searchText ?? this.searchText,
    );
  }
}