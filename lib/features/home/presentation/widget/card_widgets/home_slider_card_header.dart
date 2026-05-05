import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_tests_response_entity.dart';

class HomeSliderCardHeader extends StatelessWidget {
  final bool isDark;
  final TestOwnerEntity owner;

  const HomeSliderCardHeader({
    super.key,
    required this.isDark,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    final profilePicture = fixLocalhostUrl(owner.profilePicture);
    final isSvg = profilePicture.toLowerCase().endsWith('.svg');
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 4,
            left: SizeConfig.w(0.02),
            right: SizeConfig.w(0.03),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomAppImage(
              path: owner.profilePicture,
              height: SizeConfig.w(0.12),
              width: SizeConfig.w(0.12),
              fit: BoxFit.cover,
            ),
            //         isSvg
            // ? CustomAppImage(
            //     height: SizeConfig.w(0.12),
            //     width: SizeConfig.w(0.12),
            //     path: AppImage.carmen,
            //     fit: BoxFit.cover,
            //   )
            // : Image.network(
            //     profilePicture,
            //     height: SizeConfig.w(0.12),
            //     width: SizeConfig.w(0.12),
            //     fit: BoxFit.cover,
            //     errorBuilder: (_, __, ___) {
            //       return CustomAppImage(
            //         height: SizeConfig.w(0.12),
            //         width: SizeConfig.w(0.12),
            //         path: AppImage.carmen,
            //         fit: BoxFit.cover,
            //       );
            //     },
            //   ),
            // isSvg
            //     ? SvgPicture.network(
            //         profilePicture,
            //         height: SizeConfig.w(0.12),
            //         width: SizeConfig.w(0.12),
            //         fit: BoxFit.cover,
            //         placeholderBuilder: (_) {
            //           return CustomAppImage(
            //             height: SizeConfig.w(0.12),
            //             width: SizeConfig.w(0.12),
            //             path: AppImage.carmen,
            //             fit: BoxFit.cover,
            //           );
            //         },
            //       )
            //     : Image.network(
            //         profilePicture,
            //         height: SizeConfig.w(0.12),
            //         width: SizeConfig.w(0.12),
            //         fit: BoxFit.cover,
            //         errorBuilder: (_, __, ___) {
            //           return CustomAppImage(
            //             height: SizeConfig.w(0.12),
            //             width: SizeConfig.w(0.12),
            //             path: AppImage.carmen,
            //             fit: BoxFit.cover,
            //           );
            //         },
            //       ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      owner.name,
                      fontSize: SizeConfig.text(0.04),
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (owner.isVerified)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ),
                ],
              ),
              SizedBox(height: SizeConfig.h(0.005)),
              Row(
                children: [
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.feather,
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Flexible(
                    child: CustomTextWidget(
                      "اختبار ${owner.publishedTestsCount}",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(0.02)),
                  CustomAppImage(
                    height: SizeConfig.w(0.03),
                    width: SizeConfig.w(0.03),
                    path: AppImage.handshake,
                  ),
                  SizedBox(width: SizeConfig.w(0.01)),
                  Flexible(
                    child: CustomTextWidget(
                      "متابع ${owner.followersCount}",
                      fontSize: SizeConfig.text(0.032),
                      overflow: TextOverflow.ellipsis,
                      color: isDark
                          ? AppPalette.titleWhiteINDark
                          : AppPalette.greyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String fixLocalhostUrl(String url) {
  if (url.contains('localhost')) {
    return url.replaceFirst('http://localhost', 'http://10.237.223.187');
  }

  return url;
}
