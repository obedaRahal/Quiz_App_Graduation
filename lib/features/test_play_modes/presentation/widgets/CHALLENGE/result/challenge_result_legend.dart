import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';

class ChallengeResultLegend extends StatelessWidget {
  const ChallengeResultLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          'أنت',
          color: context.appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
        ),
        SizedBox(width: SizeConfig.w(0.015)),

        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppPalette.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: SizeConfig.w(0.02)),

        Expanded(child: DashedSectionTitle(title: 'الإجابات')),
        SizedBox(width: SizeConfig.w(0.02)),

        //SizedBox(width: 18),
        _LegendItem(title: 'الخصم', color: Color(0xFFD46BFF)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String title;
  final Color color;

  const _LegendItem({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: SizeConfig.w(0.015)),
        CustomTextWidget(
          title,
          color: context.appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
        ),
      ],
    );
  }
}
