import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university/univercity_logo.dart';

import '../../../../../../core/theme/color/app_colors.dart';
import '../../../../../../core/utils/media_query_config.dart';
import 'current_university_models.dart';

class UniversityDropdownItem extends StatelessWidget {
  final UniversityOption item;

  const UniversityDropdownItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      
      textDirection: TextDirection.rtl,
      children: [
        UniversityLogo(logoPath: item.logoPath),
        SizedBox(width: SizeConfig.w(0.02)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  item.name,
                  textAlign: TextAlign.right,
                  fontSize: SizeConfig.text(0.03),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.02),
                  ),
                  decoration: BoxDecoration(
                    color: item.isPrivate
                        ? AppPalette.primarySoft
                        : AppPalette.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomTextWidget(
                    item.isPrivate ? 'خاصة' : 'عامة',
                    fontSize: SizeConfig.text(0.022),
                    color: item.isPrivate
                        ? AppPalette.primary
                        : AppPalette.greyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}