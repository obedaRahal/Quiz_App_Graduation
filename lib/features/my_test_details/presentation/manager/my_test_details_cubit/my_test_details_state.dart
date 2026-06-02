enum MyTestDetailsTab { overview, status, reviews }

class TestDetailsMockData {
  static final mockTestDetails = TestDetails(
    id: 801,
    title: "اختبار خاص تجريبي",
    description: "هذا الاختبار غير حقيقي وهو بهدف التجريب فقط",
    difficultyLevel: "متوسط",
    price: 0,
    likesCount: 12,
    reviewsCount: 5,
    bookmarksCount: 0,
  );
}

class TestDetails {
  final int id;
  final String title;
  final String description;
  final String difficultyLevel;
  final int price;
  final int likesCount;
  final int reviewsCount;
  final int bookmarksCount;

  TestDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.price,
    required this.likesCount,
    required this.reviewsCount,
    required this.bookmarksCount,
  });
}

class MyTestDetailsState {
  final TestDetails? testDetails;
  final MyTestDetailsTab selectedTab;

  final Map<int, int> selectedSampleAnswers;

  //////////// my test status tab

  final String selectedRatingFilter;

  const MyTestDetailsState({
    this.testDetails,
    this.selectedTab = MyTestDetailsTab.overview,
    this.selectedSampleAnswers = const {},

    this.selectedRatingFilter = 'all',
  });

  MyTestDetailsState copyWith({
    TestDetails? testDetails,
    MyTestDetailsTab? selectedTab,
    Map<int, int>? selectedSampleAnswers,
    String? selectedRatingFilter,
  }) {
    return MyTestDetailsState(
      testDetails: testDetails ?? this.testDetails,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedSampleAnswers:
          selectedSampleAnswers ?? this.selectedSampleAnswers,

      selectedRatingFilter: selectedRatingFilter ?? this.selectedRatingFilter,
    );
  }
}
