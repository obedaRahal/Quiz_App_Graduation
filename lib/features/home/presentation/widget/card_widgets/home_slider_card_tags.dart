import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeSliderCardTags extends StatelessWidget {
  final bool isDark;
  final List<String> tags;

  const HomeSliderCardTags({
    super.key,
    required this.isDark,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.035),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        reverse: false,
        itemCount: tags.length,
        separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.02)),
        itemBuilder: (context, index) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: SizeConfig.w(0.35)),
            child: CustomBackgroundWithChild(
              backgroundColor: isDark
                  ? AppPalette.greyLightDark
                  : AppPalette.primarySoft,
              borderRadius: BorderRadius.circular(6),
              childHorizontalPad: 8,
              childVerticalPad: 2,
              child: CustomTextWidget(
                '# ${tags[index]}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: SizeConfig.text(0.032),
              ),
            ),
          );
        },
      ),
    );
  }
}
