import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeTopBannerCard extends StatelessWidget {
  final int index;
  final bool isDark;
  final dynamic colorScheme;
  final double circleSize;
  final double imageSize;

  const HomeTopBannerCard({
    super.key,
    required this.index,
    required this.isDark,
    required this.colorScheme,
    required this.circleSize,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.02)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          SizeConfig.w(0.05).clamp(16.0, 20.0).toDouble(),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: index == 0
                    ? AppPalette.homeContainer1
                    : index == 1
                    ? AppPalette.homeContainer2
                    : AppPalette.homeContainer3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.h(
                              0.012,
                            ).clamp(8.0, 12.0).toDouble(),
                            bottom: SizeConfig.h(
                              0.008,
                            ).clamp(5.0, 8.0).toDouble(),
                            right: SizeConfig.w(0.02),
                          ),
                          child: CustomTextWidget(
                            index == 0
                                ? "انشر معرفتك وخبراتك\n و دع الأخرين يتعلمون شيئا جديدا\n بطريقة سهلة وواضحة"
                                : index == 1
                                ? "ابدء بمتابعة مقراراتك الدراسية\n بشكل سهل وبسيط وبمتابعة\n يومية ممتعة"
                                : "شارك محتواك العلمي المفيد مع\n المجتمع لتحسين تجربة التعلم\n في مكان واحد",
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.right,
                            fontSize: SizeConfig.text(0.032).clamp(11.0, 16.0),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(0.02),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (index == 0) {
                                // context.push("/route1");
                              } else if (index == 1) {
                                // context.push("/route2");
                              } else {
                                // context.push("/route3");
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.w(0.02),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: isDark
                                      ? AppPalette.fieldColorNDark
                                      : AppPalette.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.h(
                                      0.003,
                                    ).clamp(2.0, 3.0).toDouble(),
                                    horizontal: SizeConfig.w(0.03),
                                  ),
                                  child: CustomTextWidget(
                                    index == 0
                                        ? "انشئ اختبارا جديدا"
                                        : index == 1
                                        ? "انشئ خطة دراسية"
                                        : "انشئ محتوى للمكتبة",
                                    fontSize: SizeConfig.diagonal * .015,
                                    color: index == 0
                                        ? AppPalette.homeContainer1
                                        : index == 1
                                        ? AppPalette.homeContainer2
                                        : AppPalette.homeContainer3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: circleSize * 0.82),
                ],
              ),
            ),

            Positioned(
              left: -circleSize * 0.20,
              bottom: -circleSize * 0.20,
              child: Container(
                width: circleSize * 1.21,
                height: circleSize * 1.22,
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppPalette.circleContainer1
                      : index == 1
                      ? AppPalette.circleContainer2
                      : AppPalette.circleContainer3,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              left: SizeConfig.w(0.008),
              bottom: SizeConfig.h(0.0099),
              child: CustomAppImage(
                path: index == 0
                    ? AppImage.mind1
                    : index == 1
                    ? AppImage.mind2
                    : AppImage.mind3,
                height: imageSize * 1.28,
                width: imageSize * 1.28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
