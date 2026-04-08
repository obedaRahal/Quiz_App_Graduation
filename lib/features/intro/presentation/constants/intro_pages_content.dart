import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/features/intro/data/model/intro_page_item.dart';

class IntroPagesContent {
  static List<IntroPageItem> pages = [
    IntroPageItem(
      image: AppImage.intro1,
      titleBlack: "ابدأ رحلتك التعليمية",
      titlePrimary: "بطريقتك الخاصة",
      description:
          "اكتشف تجربة تعلم فريدة ومتنوعة حيث يجمعنا كل\nما يحتاجه متلقي المعلومة في مكان واحد !",
    ),
    IntroPageItem(
      image: AppImage.intro2,
      titleBlack: "اختبارات ومحتوى ",
      titlePrimary: "على مزاجك",
      description:
      "استعد لاختبارات ومحتوى مختار خصيصًا إلك! \n بنقدملك مواد وأسئلة تناسبك وتطوّر مستواك بسرعة"
          ),
    IntroPageItem(
      image: AppImage.intro3,
      titleBlack: "خطتك الذكية للنجاح ",
      titlePrimary: "بسهولة",
      description:
      "مو بس محتوى! بنساعدك تبني خطة دراسية \n مناسبة إلك، تتابع تقدمك يوم بيوم وتوصل لهدفك \n بطريقة منظمة وسهلة"
    ),
  ];
}