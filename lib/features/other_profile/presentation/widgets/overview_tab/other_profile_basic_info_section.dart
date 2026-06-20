import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_info_details_section.dart';

class OtherProfileBasicInfoSection extends StatelessWidget {
  final String educationLevel;
  final String governorate;
  final String gender;
  final String joinedAt;
  final List<String> interestsList;

  final bool isThereCertificate;
  final VoidCallback onCertificateTap;

  const OtherProfileBasicInfoSection({
    super.key,
    required this.educationLevel,
    required this.governorate,
    required this.gender,
    required this.joinedAt,
    required this.interestsList,
    required this.isThereCertificate,
    required this.onCertificateTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isThereCertificate)
              CustomButtonWidget(
                backgroundColor: isDark
                    ? AppPalette.greyLightDark
                    : AppPalette.greyLight,
                childHorizontalPad: SizeConfig.w(0.02),
                childVerticalPad: SizeConfig.h(0.004),
                borderRadius: 5,
                onTap: onCertificateTap,
                child: CustomTextWidget(
                  "عرض الشهادة الجامعية",
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.03),
                ),
              )
            else
              const SizedBox.shrink(),

            SizedBox(width: SizeConfig.w(0.01)),

            CustomTextWidget(
              "معلومات أساسية",
              color: appColors.blackTogreyMedium,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: _ProfileBasicInfoItem(
                iconPath: AppImage.educationIcon,
                title: "المستوى",
                value: _cleanValue(educationLevel),
              ),
            ),

            const VerticalInfoDivider(),

            Expanded(
              child: _ProfileBasicInfoItem(
                iconPath: AppImage.locationIcon,
                title: "الإقامة",
                value: _cleanValue(governorate),
              ),
            ),

            const VerticalInfoDivider(),

            Expanded(
              child: _ProfileBasicInfoItem(
                iconPath: AppImage.jenderIcon,
                title: "الجنس",
                value: _cleanValue(gender),
              ),
            ),

            const VerticalInfoDivider(),

            Expanded(
              child: _ProfileBasicInfoItem(
                iconPath: AppImage.timerIcon,
                title: "انضم في",
                value: _cleanValue(joinedAt),
              ),
            ),
          ],
        ),

        if (interestsList.isNotEmpty) ...[
          SizedBox(height: SizeConfig.h(0.02)),

          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              textDirection: TextDirection.rtl,
              alignment: WrapAlignment.start,
              spacing: SizeConfig.w(0.02),
              runSpacing: SizeConfig.h(0.012),
              children: interestsList.map((interest) {
                return CustomBackgroundWithChild(
                  
                  borderRadius: BorderRadius.circular(4),
                  childHorizontalPad: SizeConfig.w(0.02),
                  childVerticalPad: SizeConfig.h(0.004),
                  backgroundColor: appColors.primarySoftTogreyLightDark,
                  child: CustomTextWidget(
                    "# $interest",
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.033),
                    textDirection: TextDirection.rtl,
                    
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  String _cleanValue(String value) {
    final clean = value.trim();

    if (clean.isEmpty) {
      return '-';
    }

    return clean;
  }
}

class _ProfileBasicInfoItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _ProfileBasicInfoItem({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _TestInfoItem(iconPath: iconPath, title: title, value: value);
  }
}

class _TestInfoItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const _TestInfoItem({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      children: [
        CustomAppImage(
          path: iconPath,
          width: SizeConfig.w(0.065),
          height: SizeConfig.w(0.065),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 3),
        CustomTextWidget(
          title,
          color: appColors.blackToGrey2Dark,
          fontSize: SizeConfig.text(0.03),
          fontFamily: AppFont.elMessiriBold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        CustomTextWidget(
          value,
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.03),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
