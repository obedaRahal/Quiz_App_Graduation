import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_stat_card.dart';

class OtherProfileGeneralStatsSection extends StatelessWidget {
  final String likesCount;
  final String commentsCount;
  final String bookMarksCount;

  const OtherProfileGeneralStatsSection({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    required this.bookMarksCount,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "احصائيات عامة",
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.012)),

        Row(
          children: [
            Expanded(
              child: OtherProfileStatCard(
                icon: FontAwesomeIcons.solidBookmark,
                value: bookMarksCount,
                description: 'اختبارًا منشورًا',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: OtherProfileStatCard(
                icon: FontAwesomeIcons.solidComment,
                value: commentsCount,
                description: 'تعليقًا للاختبارات',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.02)),

            Expanded(
              child: OtherProfileStatCard(
                icon: FontAwesomeIcons.solidThumbsUp,
                value: likesCount,
                description: 'إعجابًا للاختبارات',
              ),
            ),
          ],
        ),
      ],
    );
  }
}