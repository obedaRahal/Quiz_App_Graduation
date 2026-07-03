import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ContentInterestChip extends StatelessWidget {
  final String title;

  const ContentInterestChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: SizeConfig.w(0.34),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.030),
        vertical: SizeConfig.h(0.005),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.greyLightDark
            : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(7),
      ),
      child: CustomTextWidget(
        '# $title',
        color: Theme.of(context).colorScheme.primary,
        fontSize: SizeConfig.text(0.028).clamp(10.0, 12.0).toDouble(),
        fontWeight: FontWeight.w600,
        fontFamily: AppFont.elMessiriRegular,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}