abstract class AppRouterName {
  static const splash = 'splash';
  static const welcome = 'welcome';
  static const intro = 'intro';

  static const login = 'loginPage';
  static const register = 'registerPage';
  static const verifyEmail = 'verifyEmailPage';
  static const forgotPasswordEmail = 'forgotPasswordEmailPage';
  static const forgotPasswordOtpCode = 'forgotPasswordOtpCodePage';
  static const forgotPasswordNewPassword = 'forgotPasswordNewPasswordPage';
  static const onboarding = 'onboarding';

  static const home = 'homePage';
  static const mainLayout = 'mainLayout';
  static const detailsOfTest = 'detailsOfTest';
  static const String sharedTestRedirect = '/shared-test/:slug';
  static const allCategoriesPage = 'allCategoriesPage';
  static const laboratoryPage = 'laboratoryPage';
  static const createTestPage = 'createTestPage';
  static const createTestAiLoadingPage = 'createTestAiLoadingPage';

  static const mcqTestSessionView = 'mcqTestSessionView';
  static const challengeSetupView = 'challengeSetupView';
  static const flashcardView = 'flashcardView';

  static const myTestDetails = 'myTestDetails';
  static const myPrivateTestDetails = 'myPrivateTestDetails';

  static const otherProfile = 'otherProfile';
  static const String sharedProfileRedirect = 'sharedProfileRedirect';
  static const String myProfile = 'myProfile';
  static const myProfileBookmarks = 'myProfileBookmarks';
  static const myProfileFolderEditor = 'myProfileFolderEditor';
  static const String otherContentDetails = 'otherContentDetails';

  static const String studyPlan = 'studyPlan';
  static const String createStudyPlan = 'createStudyPlan';
  static const String manageStudyPlans = 'manageStudyPlans';
  static const String studyPlanDetails = 'studyPlanDetails';

  static const String studyTaskDetails = 'studyTaskDetails';
}

abstract class AppRouterPath {
  static String sharedTestRedirectPath(String slug) => '/shared-test/$slug';

  static const String sharedProfileRedirect = '/share/profiles/:slug';
  static String sharedProfileRedirectPath(String slug) =>
      '/share/profiles/$slug';

  static const splash = '/';
  static const welcome = '/welcome';
  static const intro = '/intro';

  static const login = '/loginPage';
  static const register = '/registerPage';
  static const verifyEmail = '/verifyEmailPage';
  static const forgotPasswordEmail = '/forgotPasswordEmailPage';
  static const forgotPasswordOtpCode = '/forgotPasswordOtpCodePage';
  static const forgotPasswordNewPassword = '/forgotPasswordNewPasswordPage';

  //static const intro = '/intro';
  static const onboarding = '/onboarding';

  static const home = '/homePage';
  static const mainLayout = '/mainLayout';
  static const detailsOfTest = '/detailsOfTest';
  static const String sharedTestRedirect = '/shared-test/:slug';
  static const allCategoriesPage = '/allCategoriesPage';
  static const laboratoryPage = '/laboratoryPage';
  static const createTestPage = '/createTestPage';
  static const createTestAiLoadingPage = '/createTestAiLoadingPage';
  static const mcqTestSessionView = '/mcqTestSessionView';
  static const challengeSetupView = '/challengeSetupView';
  static const flashcardView = '/flashcardView';

  static const myTestDetails = '/myTestDetails';
  static const myPrivateTestDetails = '/myPrivateTestDetails';

  static const otherProfile = '/otherProfile';
  static const myProfile = '/myProfile';
  static const myProfileBookmarks = '/my-profile-bookmarks';
  static const myProfileFolderEditor = '/myProfileFolderEditor';
  static const otherContentDetails = '/otherContentDetails';

  static const studyPlan = '/studyPlan';
  static const String createStudyPlan = '/study-plan/create';
  static const String manageStudyPlans = '/manageStudyPlans';
  static const String studyPlanDetails = '/study-plan/details';

  static const String studyTaskDetails = '/study-task-details';
}
