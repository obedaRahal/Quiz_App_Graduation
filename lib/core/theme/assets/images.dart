class AppImage {
  static const _baseImageLight = 'assets/images/light';
  static const _baseImageDark = 'assets/images/dark';

  static const _baseIcon = 'assets/icons';
  static const _baseLottie = 'assets/lottie';
  static const _baseGif = 'assets/gif';

  ////////////////////// light image ////////////////////////////
  //////////////////////////////////////////////////////////////

  ///////// splash view //////////////////
  static String get logo => '$_baseIcon/logo.png';
  static String get logoLight => '$_baseIcon/logolight.svg';

  static String get logoDark => '$_baseIcon/logodark.svg';

  static String get welcomeLight => '$_baseImageLight/welcomeLight.png';

  //////// introoooo ////////////////
  static String get intro1 => '$_baseImageLight/intro1light.png';
  static String get intro2 => '$_baseImageLight/intro2light.png';
  static String get intro3 => '$_baseImageLight/intro3light.svg';

  ////////////////////// darkkkk image ////////////////////////////
  //////////////////////////////////////////////////////////////
  static String get welcomeDark => '$_baseImageDark/welcomeDark.png';
}
