import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

class FlashcardCard extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final bool isRevealed;
  final double slideX;
  final double opacity;
  final VoidCallback onTap;
  final Color frontColor;
  final Color secondColor;
  final Color thirdColor;
  final bool hasHint;
  final VoidCallback onHintTap;

  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;

  const FlashcardCard({
    super.key,
    required this.question,
    required this.isRevealed,
    required this.slideX,
    required this.opacity,
    required this.onTap,
    required this.frontColor,
    required this.secondColor,
    required this.thirdColor,
    required this.hasHint,
    required this.onHintTap,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.09)),
            child: Transform.translate(
              offset: Offset(0, SizeConfig.h(0)),
              child: Transform.rotate(
                angle: 0.15,
                child: _FlashcardBackLayer(color: thirdColor),
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.075)),
            child: Transform.translate(
              offset: Offset(0, SizeConfig.h(0)),
              child: Transform.rotate(
                angle: 0.06,
                child: _FlashcardBackLayer(color: secondColor),
              ),
            ),
          ),
        ),

        AnimatedSlide(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          offset: Offset(slideX / MediaQuery.of(context).size.width, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: opacity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.05)),
              child: GestureDetector(
                onTap: onTap,
                onHorizontalDragStart: onHorizontalDragStart,
                onHorizontalDragUpdate: onHorizontalDragUpdate,
                onHorizontalDragEnd: onHorizontalDragEnd,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(question.questionId),
                  tween: Tween<double>(begin: 0, end: isRevealed ? math.pi : 0),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    final isBackVisible = value > math.pi / 2;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(value),
                      child: isBackVisible
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: _FlashcardBack(
                                question: question,
                                color: frontColor,
                                onHintTap: onHintTap,
                                hasHint: hasHint,
                              ),
                            )
                          : _FlashcardFront(
                              question: question,
                              color: frontColor,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlashcardBackLayer extends StatelessWidget {
  final Color color;

  const _FlashcardBackLayer({required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _FlashcardFront extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final Color color;

  const _FlashcardFront({required this.question, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.05)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        alignment: Alignment.center,
        backgroundColor: color,
        borderRadius: BorderRadius.circular(20),

        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FaIcon(
                  FontAwesomeIcons.arrowRotateRight,
                  color: AppPalette.white,
                ),
              ],
            ),

            CustomTextWidget(
              question.questionText,
              color: AppPalette.white,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: SizeConfig.h(0.025)),

            CustomBackgroundWithChild(
              backgroundColor: Colors.transparent,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.007),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppPalette.white),
              child: CustomTextWidget(
                'عرض الجواب',
                color: AppPalette.white,
                fontFamily: AppFont.elMessiriMedium,
                fontSize: SizeConfig.text(0.028),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final Color color;
  final bool hasHint;
  final VoidCallback onHintTap;

  const _FlashcardBack({
    required this.question,
    required this.color,
    required this.hasHint,
    required this.onHintTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final correctOption = question.correctOption;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.05)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        alignment: Alignment.center,

        backgroundColor: color,
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasHint)
                  GestureDetector(
                    onTap: onHintTap,
                    child: const FaIcon(
                      FontAwesomeIcons.lightbulb,
                      color: AppPalette.white,
                    ),
                  )
                else
                  const SizedBox(),
                FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: AppPalette.white,
                ),
              ],
            ),

            CustomTextWidget(
              correctOption?.optionText ?? 'لا توجد إجابة محددة',
              color: AppPalette.white,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: SizeConfig.h(0.025)),

            CustomBackgroundWithChild(
              backgroundColor: Colors.transparent,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.007),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppPalette.white),
              child: CustomTextWidget(
                'عرض السؤال',
                color: AppPalette.white,
                fontFamily: AppFont.elMessiriMedium,
                fontSize: SizeConfig.text(0.028),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
