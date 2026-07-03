import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';

class MyProfileInterestCard extends StatelessWidget {
  final InterestItemEntity interest;
  final bool isSelected;
  final VoidCallback onTap;

  const MyProfileInterestCard({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  Color _parseColor(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return AppPalette.greyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final iconColor = isSelected
        ? AppPalette.white
        : _parseColor(interest.iconColor);

    final iconUrl = interest.iconSvg;

    final backgroundColor = isSelected
        ? appColors.primaryToPrimaryDark
        : isDark
            ? AppPalette.fieldColorNDark
            : AppPalette.white;

    final borderColor = isSelected
        ? appColors.primaryToPrimaryDark
        : isDark
            ? AppPalette.borderFieldColorNDark
            : const Color(0xFFEDEDED);

    final textColor = isSelected
        ? AppPalette.white
        : isDark
            ? AppPalette.titleWhiteINDark
            : AppPalette.greyMedium;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.026)),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            if (!isDark && !isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: SizeConfig.w(0.075),
              height: SizeConfig.w(0.075),
              child: iconUrl.isEmpty
                  ? Icon(
                      Icons.category_rounded,
                      color: iconColor,
                      size: SizeConfig.text(0.055),
                    )
                  : SvgPicture.network(
                      iconUrl,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                      placeholderBuilder: (_) => Icon(
                        Icons.category_rounded,
                        color: iconColor,
                        size: SizeConfig.text(0.055),
                      ),
                    ),
            ),

            SizedBox(width: SizeConfig.w(0.018)),

            Expanded(
              child: CustomTextWidget(
                interest.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.text(0.032),
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}