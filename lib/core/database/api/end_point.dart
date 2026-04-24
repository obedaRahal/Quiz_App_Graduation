class EndPoints {
  //static const String baseUrl = 'http://localhost/api/v1/user-mobile';
  static const String baseUrl = 'http://192.168.1.102/api/v1/user-mobile';
  static const String refreshToken = 'http://192.168.137.88/api/refresh';

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
      // Auth ///////////////////
  static const String register = 'user-mobile/auth/register';
  static const String verifyEmail = 'user-mobile/auth/verify-email';
  static const String login = 'user-mobile/auth/login';
  static const String resendOtp = 'user-mobile/auth/reset-send-otp';
  static const String forgotPasswordRequestOtp =
      'user-mobile/auth/forgot-password/request-otp';
  static const String forgotPasswordVerifyOtp =
      'user-mobile/auth/forgot-password/verify-otp';
  static const String forgotPasswordResendOtp =
      'user-mobile/auth/forgot-password/resend-otp';
  static const String forgotPasswordReset =
      'user-mobile/auth/forgot-password/reset';
}
