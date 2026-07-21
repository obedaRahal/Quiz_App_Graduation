import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_users_response_entity.dart';

class InstructorCard extends StatelessWidget {
  final RecommendedUserEntity item;
  final VoidCallback onProfileTap;

  const InstructorCard({
    super.key,
    required this.item,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarUrl = item.avatarUrl;
    final isSvg = avatarUrl.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onProfileTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xffF2F3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: isSvg
                  ? SvgPicture.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      placeholderBuilder: (_) {
                        return CustomAppImage(
                          path: AppImage.carmen,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return CustomAppImage(
                          path: AppImage.carmen,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            CustomTextWidget(
              item.name,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: SizeConfig.text(0.032).clamp(10.0, 12.0),
              color: isDark
                  ? AppPalette.titleWhiteINDark
                  : AppPalette.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
