import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';

class StudyTaskDetailsHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const StudyTaskDetailsHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.018),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderActionButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: onBackTap,
          ),
          CustomTextWidget(
            'تفاصيل المهمة',
            fontSize: SizeConfig.text(0.047),
            fontFamily: AppFont.elMessiriBold,
            color: context.appColors.blackToGrey2Dark,
          ),
        ],
      ),
    );
  }
}
