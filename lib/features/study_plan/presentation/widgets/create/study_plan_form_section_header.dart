import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanFormSectionHeader extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const StudyPlanFormSectionHeader({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppImage(
              path: image,
              color: titleColor,
            ),
            SizedBox(
              width: SizeConfig.w(0.018),
            ),
            Expanded(
              child: CustomTextWidget(
                title,
                fontSize: SizeConfig.text(0.043),
                fontWeight: FontWeight.w900,
                color: titleColor,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.h(0.006),
        ),
        CustomTextWidget(
          description,
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 3,
        ),
      ],
    );
  }
}