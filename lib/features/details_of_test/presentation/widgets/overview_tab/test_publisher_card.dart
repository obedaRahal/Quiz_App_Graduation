import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestPublisherCard extends StatelessWidget {
  final String name;
  final String profilePicture;
  final bool isVerified;
  final int followersCount;
  final int followingCount;
  final int publishedTestsCount;
  final bool isFollowing;
  final VoidCallback onFollowTap;

  const TestPublisherCard({
    super.key,
    required this.name,
    required this.profilePicture,
    required this.isVerified,
    required this.followersCount,
    required this.followingCount,
    required this.publishedTestsCount,
    required this.isFollowing,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "الناشر",
          color: AppPalette.black,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.005)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            //SvgPicture.network(profilePicture),
            CustomAppImage(
              path: profilePicture,
              width: SizeConfig.w(0.145),
              height: SizeConfig.h(0.08),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10),
              
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Flexible(
                        child: CustomTextWidget(
                          name,
                          color: AppPalette.black,
                          fontFamily: AppFont.elMessiriSemiBold,
                          fontSize: SizeConfig.text(0.038),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),

                      if (isVerified) ...[
                        const SizedBox(width: 5),
                        CustomAppImage(
                          path: AppImage.verifyCheck,
                          width: 13,
                          height: 13,
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: SizeConfig.h(0.004)),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      _PublisherStat(
                        label: "اختبار",
                        value: "$publishedTestsCount",
                      ),
                      _DotSeparator(),
                      _PublisherStat(label: "يتابع", value: "$followingCount"),
                      _DotSeparator(),
                      _PublisherStat(label: "متابع", value: "$followersCount"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            CustomButtonWidget(
              backgroundColor: isFollowing
                  ? AppPalette.greyMedium
                  : AppPalette.primary,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.006),
              borderRadius: 6,
              onTap: onFollowTap,
              child: CustomTextWidget(
                isFollowing ? "إلغاء" : "متابعة",
                color: AppPalette.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PublisherStat extends StatelessWidget {
  final String label;
  final String value;

  const _PublisherStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        CustomTextWidget(
          value,
          color: AppPalette.black,
          fontSize: SizeConfig.text(0.035),
          fontFamily: AppFont.elMessiriBold,
        ),
        SizedBox(width: 3),
        CustomTextWidget(
          label,
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.032),
        ),
      ],
    );
  }
}

class _DotSeparator extends StatelessWidget {
  const _DotSeparator();

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      "•",
      color: AppPalette.greyMedium,
      fontSize: SizeConfig.text(0.035),
    );
  }
}
