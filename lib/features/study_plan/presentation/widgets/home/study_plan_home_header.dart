import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';

class StudyPlanHomeHeader extends StatelessWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionTap;

  const StudyPlanHomeHeader({
    super.key,
    this.title = 'الخطة الدراسية',
    this.actionIcon = Icons.add_rounded,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
          HeaderActionButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: onActionTap,
          ),
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.055),
          fontFamily: AppFont.elMessiriBold,
          color: context.appColors.blackToGrey2Dark,
        ),
      ],
    );
  }
}
