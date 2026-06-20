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
    final query = _normalizeArabicText(searchText);

    if (query.isEmpty) return categories;

    return categories
        .map((category) {
          final normalizedCategoryTitle = _normalizeArabicText(category.title);

          if (normalizedCategoryTitle.contains(query)) {
            return category;
          }

          final filteredInterests = category.interests.where((interest) {
            final normalizedInterestName = _normalizeArabicText(interest.name);
            return normalizedInterestName.contains(query);
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
    bool clearErrorMessage = false,
    List<InterestCategoryEntity>? categories,
    String? searchText,
  }) {
    return AllInterestsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      searchText: searchText ?? this.searchText,
    );
  }
}

String _normalizeArabicText(String text) {
  return text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[\u064B-\u065F]'), '')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}