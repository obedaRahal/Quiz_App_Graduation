class EndPoints {
  //static const String baseUrl = 'http://localhost/api/v1/user-mobile';
  static const String baseUrl = 'http://10.237.223.187/api/v1/user-mobile';
  static const String refreshToken = 'http://10.237.223.187/api/v1/refresh';
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

  // details of test
  static String otherTestDetailsOverview(int testId) =>
      '$baseUrl/test/tests-details/other/$testId';
  static String otherTestDetailsSample(int testId) =>
      '$baseUrl/test/tests-details/other/sample/$testId';
  static String otherTestDetailsReviews({
    required int testId,
    required String rating,
  }) => '$baseUrl/test/test-details/reviews/$testId?rating=$rating';

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
  // laboratory
  static String testsByInterest(int interestId) {
    return '/home/test-by-interest/$interestId';
  }
  static const String searchLabTests  =
    '/lab/search';
    static const String labRecommendedTests =
    '/lab/recommended-tests';
}
