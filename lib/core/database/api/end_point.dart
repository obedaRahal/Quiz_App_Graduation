import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_state.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';

class EndPoints {
  static const String baseUrl = 'http://localhost/api/v1/user-mobile';
  //static const String baseUrl = 'http://localhost/api/v1/user-mobile';
  // static const String baseUrl = 'http://192.168.138.1/api/v1/user-mobile';
  static const String refreshToken = 'http://localhost/api/v1/refresh';
  // authhhhhh
  //static const String registerCitizen = 'citizen/register';

  // onboarding ////////////////
  static const String onboardingDiscoverySource =
      '$baseUrl/auth/onboarding/discovery-source';
  static const String onboardingEducationLevel =
      '$baseUrl/auth/onboarding/education-level';
  static const String onboardingSchoolStage =
      '$baseUrl/auth/onboarding/school-stage';
  static const String onboardingCurrentUniversityProfile =
      '$baseUrl/auth/onboarding/university-profile';
  static const String onboardingGraduateAcademicProfile =
      '$baseUrl/auth/onboarding/graduate-academic-profile';
  static const String onboardingInterests =
      '$baseUrl/auth/onboarding/interests';
  static const String onboardingUserInterests =
      '$baseUrl/auth/onboarding/user-interests';
  static const String onboardingProgressPreview =
      '$baseUrl/auth/onboarding/progress-preview';

  // Auth ///////////////////
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String resendOtp = '/auth/reset-send-otp';
  static const String forgotPasswordRequestOtp =
      '/auth/forgot-password/request-otp';
  static const String forgotPasswordVerifyOtp =
      '/auth/forgot-password/verify-otp';
  static const String forgotPasswordResendOtp =
      '/auth/forgot-password/resend-otp';
  static const String forgotPasswordReset = '/auth/forgot-password/reset';
  static const String recommendedTests = '/home/recommended-tests';
  static const String recommendedInterests = '/home/recommended-interests';
  static const String recommendedUsers = '/home/recommended-users';
  static const String allInterests = '/home/all-interests';

  // Create Test
  static const String createManualTest = '/lab/create-test';

  static const String aiQuestionGenerations = '/lab/ai-question-generations';

  static const String aiQuestionGenerationDailyLimit =
      '/lab/ai-question-generation/daily-limit';

  static const String filterTests = '/test/tests/filter';

  static String aiQuestionGenerationStatus(int generationRequestId) {
    return '/lab/ai-question-generations/$generationRequestId';
  }

  // Edit My Tests
  static String getEditableTestQuestions(int testId) {
    return '$baseUrl/test/content/$testId';
  }

  static String updateTest(int testId) {
    return '$baseUrl/test/update/test/$testId';
  }

  // Create Content
  static const String createContent = '/library/create-content';
// Edit Content
  static String updateContent(int contentId) =>
    '/library/update/material/$contentId';
  // Other Content Details
  static String otherContentDetails(int id) =>
      '/library/library-materials-details/other/$id';
  static const String likeContent = '/library/like';

  static const String unlikeContent = '/library/unlike';

  static String bookmarkContent(int id) => '/library/bookmark/$id';

  static String unbookmarkContent(int id) => '/library/unbookmark/$id';
  static String reportContent(int id) => '/library/reports/$id';
  static String downloadContent(int id) => '/library/download/$id';
  static String similarContent(int contentId) => '/library/similar/$contentId';
  static String followPublisher(int publisherId) =>
      '/users-profile/follow/$publisherId';
  static String unfollowPublisher(int publisherId) =>
      '/users-profile/unfollow/$publisherId';
  // My Content Details
  static String myPublicContentDetails(int id) =>
      '/library/library-materials-details/my-public/$id';
  static String deleteMyContent(int contentId) =>
      '/library/delete/material/$contentId';
  // details of test
  static String otherTestDetailsOverview(int testId) =>
      '$baseUrl/test/tests-details/other/$testId';
  static String otherTestDetailsSample(int testId) =>
      '$baseUrl/test/tests-details/other/sample/$testId';
  static String otherTestDetailsReviews({
    required int testId,
    required String rating,
    required int page,
  }) => '$baseUrl/test/test-details/reviews/$testId?rating=$rating&page=$page';

  static String otherTestDetailsLike(int testId) =>
      '$baseUrl/test/like/$testId';

  static String otherTestDetailsUnlike(int testId) =>
      '$baseUrl/test/unlike/$testId';

  static String otherTestDetailsBookmark(int testId) =>
      '$baseUrl/test/bookmark/$testId';

  static String otherTestDetailsUnbookmark(int testId) =>
      '$baseUrl/test/unbookmark/$testId';

  static String followCreator(int creatorId) =>
      '$baseUrl/users-profile/follow/$creatorId';

  static String unfollowCreator(int creatorId) =>
      '$baseUrl/users-profile/unfollow/$creatorId';

  static String downloadTestFile(int testId) =>
      '$baseUrl/test/download/$testId';

  static String addTestReview(int testId) => '$baseUrl/test/add/review/$testId';

  static String updateTestReview(int testId) =>
      '$baseUrl/test/update/review/$testId';

  static String deleteTestReview(int testId) =>
      '$baseUrl/test/delete/review/$testId';

  static String addFeedbackOnReview(int reviewId) =>
      '$baseUrl/test/add/feedback-on-review/$reviewId';

  static String deleteFeedbackOnReview(int reviewId) =>
      '$baseUrl/test/delete/feedback-on-review/$reviewId';

  static String reportReview(int reviewId) =>
      '$baseUrl/test/reports/review/$reviewId';

  static String reportTest(int testId) => '$baseUrl/test/reports/$testId';

  static String testShareLink(int testId) => '$baseUrl/test/share-link/$testId';

  static String sharedTestLink(String slug) => '$baseUrl/test/shared/$slug';

  //  get list of likes and bookmarks on TEST
  static String testInteractionUsers({
    required int testId,
    required TestInteractionUsersType type,
    String search = '',
    String? cursor,
  }) {
    final query = <String, String>{};

    if (search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }

    final queryString = query.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final path = switch (type) {
      TestInteractionUsersType.likes => 'like-list',
      TestInteractionUsersType.bookmarks => 'bookmark-list',
    };

    final base = '$baseUrl/test/$path/$testId';

    return queryString.isEmpty ? base : '$base?$queryString';
  }

  static String createStripeCheckoutSession({required int testId}) =>
      '$baseUrl/test/payments/stripe/$testId';

  static String getTestPlayContent(int testId) {
    return '$baseUrl/test/content/$testId';
  }

  // laboratory
  static String testsByInterest(int interestId) {
    return '/home/test-by-interest/$interestId';
  }

  static const String searchLabTests = '/lab/search';
  static const String labRecommendedTests = '/lab/recommended-tests';
  // Library
  static const String libraryShow = '/library/show';
  static const String librarySearch = '/library/search';
  // Test By Interest
  static const String testByInterest = '/home/test-by-interest';
  static const String searchTestByInterest = '/home/search-test-by-interest';

  //// my public test details
  static String myPublicTestDetailsOverview(int testId) =>
      '$baseUrl/test/tests-details/my-public/$testId';
  static String myPublicTestStatusHistory(int testId) =>
      '$baseUrl/test/tests-details/my-public/status-history/$testId';

  static String myPublicTestReviews({
    required int testId,
    required String rating,
    required int page,
  }) =>
      '$baseUrl/test/tests-details/my-public/reviews/$testId?rating=$rating&page=$page';

  static String myTestModifications({
    required int testId,
    required int roundId,
  }) =>
      '$baseUrl/test/tests-details/my-public/status-history/$testId/revision-request/$roundId';

  static String myPrivateTestDetailsOverview(int testId) =>
      '$baseUrl/test/tests-details/my-private/$testId';

  static String deleteMyTest(int testId) => '$baseUrl/test/delete/test/$testId';

  static String registerTestAttemptInteraction(int testId) =>
      '$baseUrl/test/attempts/$testId';

  /////////////////// other profileeeeeeeeeee //////////////////////
  static String otherProfileOverview(int userId) =>
      '$baseUrl/users-profile/overview/$userId';

  static String otherProfileTests({
    required int userId,
    required String tab,
    String? cursor,
  }) {
    final query = <String, String>{'tab': tab};

    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }

    final queryString = query.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    return '$baseUrl/users-profile/test/$userId?$queryString';
  }

  static String otherProfileFolders({required int userId, String? cursor}) {
    final query = <String, String>{};

    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }

    final queryString = query.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final base = '$baseUrl/users-profile/folder/$userId';

    return queryString.isEmpty ? base : '$base?$queryString';
  }

  static String otherProfileContent({
    required int userId,
    required String tab,
    String? cursor,
  }) {
    final query = <String, String>{'tab': tab};

    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }

    final queryString = query.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    return '$baseUrl/users-profile/content/$userId?$queryString';
  }

  static String folderBookmarkAction({required int folderId}) {
    return '$baseUrl/users-profile/folder-bookmarks/$folderId';
  }

  static String saveContentBookmark({required int contentId}) {
    return '$baseUrl/library/bookmark/$contentId';
  }

  static String removeContentBookmark({required int contentId}) {
    return '$baseUrl/library/unbookmark/$contentId';
  }

  static String otherProfileFolderDetails({required int folderId}) {
    return '$baseUrl/users-profile/folder-details/$folderId';
  }

  static String otherProfileShareLink({required int userId}) {
    return '$baseUrl/users-profile/share-link/$userId';
  }

  static String otherProfileReceive({required String slug}) {
    return '$baseUrl/users-profile/shared/${Uri.encodeComponent(slug)}';
  }

  static String otherProfileConnections({
    required int userId,
    required OtherProfileConnectionsType type,
    String search = '',
    String? cursor,
  }) {
    final query = <String, String>{};

    if (search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }

    final queryString = query.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final path = switch (type) {
      OtherProfileConnectionsType.followers => 'followers',
      OtherProfileConnectionsType.following => 'following',
    };

    final base = '$baseUrl/users-profile/$path/$userId';

    return queryString.isEmpty ? base : '$base?$queryString';
  }

  static String otherProfileAcademicCertificate({required int userId}) {
    return '$baseUrl/users-profile/academic-certificate/$userId';
  }

  /////////////////// my profile ///////////////
  static String myProfilePersonalInfo({required int userId}) {
    return '$baseUrl/my-profile/basic-info/$userId';
  }

  static String editMyProfilePersonalInfo({required int userId}) {
    return '$baseUrl/my-profile/update/basic-info/$userId';
  }

  static String editMyProfileAcademicInfo({required int userId}) {
    return '$baseUrl/my-profile/update/academic-info/$userId';
  }

  static String editMyProfileScientificInterests({required int userId}) {
    return '$baseUrl/my-profile/update/scientific-interests/$userId';
  }

  static String editMyProfilePicture({
    required int userId,
    required String type,
  }) {
    return '$baseUrl/my-profile/update/photo/$userId?type=$type';
  }

  static String deleteMyProfilePicture({
    required int userId,
    required String type,
  }) {
    return '$baseUrl/my-profile/delete/photo/$userId?type=$type';
  }

  static String myProfileBookmarks({required String tab, String? cursor}) {
    final endpoint = '$baseUrl/my-profile/bookmarks?tab=$tab';

    if (cursor == null || cursor.trim().isEmpty) {
      return endpoint;
    }

    return '$endpoint&cursor=$cursor';
  }

  static String myProfileLibrary({
    required int userId,
    required String tab,
    String? cursor,
  }) {
    final endpoint = '$baseUrl/my-profile/library/$userId?tab=$tab';

    if (cursor == null || cursor.trim().isEmpty) {
      return endpoint;
    }

    return '$endpoint&cursor=$cursor';
  }

  static String searchMyProfileLibrary({
    required String query,
    String mode = 'user_owned',
    String? cursor,
  }) {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final endpoint =
        '$baseUrl/my-profile/library-material/search?query=$encodedQuery&mode=$mode';

    if (cursor == null || cursor.trim().isEmpty) {
      return endpoint;
    }

    return '$endpoint&cursor=$cursor';
  }

  static String myProfileFolders({
    required int userId,
    required String tab,
    String? cursor,
  }) {
    final endpoint = '$baseUrl/my-profile/folder/$userId?tab=$tab';

    if (cursor == null || cursor.trim().isEmpty) {
      return endpoint;
    }

    return '$endpoint&cursor=$cursor';
  }
}
