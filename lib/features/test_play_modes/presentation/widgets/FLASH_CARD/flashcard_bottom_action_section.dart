import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class FlashcardBottomActionSection extends StatelessWidget {
  final TestPlayModesState state;
  final VoidCallback onKnow;
  final VoidCallback onDontKnow;

  const FlashcardBottomActionSection({
    super.key,
    required this.state,
    required this.onKnow,
    required this.onDontKnow,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.045),
        vertical: SizeConfig.h(0.016),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: _FlashcardActionButton(
              title: 'أعرفها',
               desc: 'لن تعرض ثانية',
              icon: Icons.check_rounded,
              color: AppPalette.green,
              onTap: onKnow,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.07)),

          Expanded(
            child: _FlashcardActionButton(
              title: 'لا أعرفها',
              desc: 'بعد أربعة أوراق',
              icon: Icons.close_rounded,
              color: AppPalette.red,
              onTap: onDontKnow,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashcardActionButton extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FlashcardActionButton({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        // height: SizeConfig.h(0.052),
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppPalette.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: color, blurRadius: 5)],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: color, size: SizeConfig.h(0.026)),
            SizedBox(width: SizeConfig.w(0.012)),
            CustomTextWidget(
              title,
              color: color,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.032),
            ),
            SizedBox(width: SizeConfig.w(0.012)),
            CustomTextWidget(
              desc,
              color: AppPalette.black,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.028),
            ),
          ],
        ),
      ),
    );
  }
}
