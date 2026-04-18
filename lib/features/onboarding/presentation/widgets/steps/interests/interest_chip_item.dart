import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';

import '../../../../../../core/theme/color/app_colors.dart';
import '../../../../../../core/utils/media_query_config.dart';

class InterestChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const InterestChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final borderColor = isSelected ? appColors.primaryToPrimaryDark : appColors.borderFieldColorNLightToborderFieldColorNDark;
    final backgroundColor =
        isSelected ? appColors.primarySoftTogreyLightDark :appColors.greyToGreyMediumDark;
    final textColor = isSelected ? appColors.primaryToPrimaryDark : AppPalette.greyMedium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.025),
            vertical: SizeConfig.h(0.008),
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected && onRemove != null) ...[
                GestureDetector(
                  onTap: onRemove,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close,
                    size: 15,
                    color: AppPalette.primary,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.015)),
              ],
              Flexible(
                child: CustomTextWidget(
                  label,
                  color: textColor,
                  fontSize: SizeConfig.text(0.03),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}