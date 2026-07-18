import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';

class ManageStudyPlansHeader extends StatelessWidget {
  final int plansCount;
  final int maxPlansCount;
  final VoidCallback onBackTap;

  const ManageStudyPlansHeader({
    super.key,
    required this.plansCount,
    required this.maxPlansCount,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        CustomTextWidget(
          'إدارة الخطط',
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.052),
          color: appColors.blackToGrey2Dark,
          textAlign: TextAlign.right,
        ),

        SizedBox(width: SizeConfig.w(0.01)),

        CustomTextWidget(
          'الخطط المسموحة $plansCount/$maxPlansCount',
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.027),
          color: appColors.primaryToPrimaryDark,
          maxLines: 1,
        ),

        Spacer(),

        HeaderActionButton(
          icon: Icons.arrow_back_ios_rounded,
          onTap: onBackTap,
        ),
      ],
    );
  }
}
