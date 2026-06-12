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

  static const mcqTestSessionView = 'mcqTestSessionView';
  static const challengeSetupView = 'challengeSetupView';
  static const flashcardView = 'flashcardView';

  static const myTestDetails = 'myTestDetails';
  static const myPrivateTestDetails = 'myPrivateTestDetails';


  static const otherProfile = 'otherProfile';
}

abstract class AppRouterPath {
  static String sharedTestRedirectPath(String slug) => '/shared-test/$slug';

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

  static const mcqTestSessionView = '/mcqTestSessionView';
  static const challengeSetupView = '/challengeSetupView';
  static const flashcardView = '/flashcardView';


  static const myTestDetails = '/myTestDetails';
  static const myPrivateTestDetails = '/myPrivateTestDetails';


  static const otherProfile = '/otherProfile';
}
