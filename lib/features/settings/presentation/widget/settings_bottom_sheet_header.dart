import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SettingsBottomSheetHeader extends StatelessWidget {
  final String title;

  const SettingsBottomSheetHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Column(
      children: [
        SizedBox(height: SizeConfig.h(0.012)),

        Container(
          width: SizeConfig.w(0.12),
          height: 4,
          decoration: BoxDecoration(
            color: isDark ? AppPalette.greyLightDark : AppPalette.greyLight,
            borderRadius: BorderRadius.circular(30),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.014)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
          child: CustomTextWidget(
            title,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.044),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: SizeConfig.h(0.01)),

        const CustomDivider(height: 10, thickness: 2, isDashed: true),
      ],
    );
  }
}
