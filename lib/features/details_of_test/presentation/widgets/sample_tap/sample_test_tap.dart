import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SampleTestTab extends StatelessWidget {
  const SampleTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      PreviewQuestionUiModel(
        number: 1,
        question:
            "أي من بنى التحكم بالنفاذ الآتية تنشئ لكل مستخدم بطاقة تصف موارد الحوسبة التي يحق له النفاذ إليها والعمليات التي يستطيع إنجازها؟",
        options: const [
          PreviewOptionUiModel(
            letter: "A",
            text: "مصفوفات التحكم بالنفاذ",
            isCorrect: false,
          ),
          PreviewOptionUiModel(
            letter: "B",
            text: "قوائم التحكم بالنفاذ",
            isCorrect: true,
          ),
          PreviewOptionUiModel(
            letter: "C",
            text: "تذاكر المقدرة",
            isCorrect: false,
          ),
          PreviewOptionUiModel(
            letter: "D",
            text: "جدول التفويض الزمني الخاص بالمصفوفات",
            isCorrect: false,
          ),
        ],
      ),
    ];

    return Column(
      children: questions.map((question) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
          child: SampleQuestionCard(question: question),
        );
      }).toList(),
    );
  }
}

class PreviewQuestionUiModel {
  final int number;
  final String question;
  final List<PreviewOptionUiModel> options;

  const PreviewQuestionUiModel({
    required this.number,
    required this.question,
    required this.options,
  });
}

class PreviewOptionUiModel {
  final String letter;
  final String text;
  final bool isCorrect;

  const PreviewOptionUiModel({
    required this.letter,
    required this.text,
    required this.isCorrect,
  });
}

class SampleQuestionCard extends StatefulWidget {
  final PreviewQuestionUiModel question;

  const SampleQuestionCard({super.key, required this.question});

  @override
  State<SampleQuestionCard> createState() => _SampleQuestionCardState();
}

class _SampleQuestionCardState extends State<SampleQuestionCard> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      backgroundColor: AppPalette.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: AppPalette.borderFieldColorNLight),
      childVerticalPad: SizeConfig.h(0.015),
      childHorizontalPad: SizeConfig.w(0.022),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _QuestionHeader(number: widget.question.number),

          SizedBox(height: SizeConfig.h(0.008)),

          CustomTextWidget(
            widget.question.question,
            textAlign: TextAlign.end,
            color: AppPalette.black,
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.035),
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          CustomTextWidget(
            "الخيارات",
            color: AppPalette.black,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.035),
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          ...widget.question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
              child: SampleOptionItem(
                option: option,
                isSelected: selectedIndex == index,
                isRevealed: selectedIndex != null,
                onTap: () {
                  if (selectedIndex != null) return;
                  setState(() => selectedIndex = index);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final int number;

  const _QuestionHeader({required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          "السؤال",
          color: AppPalette.primary,
          //fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.035),
        ),
        CustomBackgroundWithChild(
          backgroundColor: AppPalette.primarySoft,
          childHorizontalPad: SizeConfig.w(.022),
          childVerticalPad: SizeConfig.h(.002),
          borderRadius: BorderRadius.circular(10),
          child: CustomTextWidget(
            "#$number",
            color: AppPalette.primary,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.035),
          ),
        ),
      ],
    );
  }
}

class SampleOptionItem extends StatelessWidget {
  final PreviewOptionUiModel option;
  final bool isSelected;
  final bool isRevealed;
  final VoidCallback onTap;

  const SampleOptionItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool showCorrect = isRevealed && option.isCorrect;
    final bool showWrong = isRevealed && isSelected && !option.isCorrect;

    final Color backgroundColor = showCorrect
        ? AppPalette.greenSoft
        : showWrong
        ? AppPalette.red.withOpacity(0.12)
        : AppPalette.grey;

    final Color borderColor = showCorrect
        ? AppPalette.green
        : showWrong
        ? AppPalette.red
        : AppPalette.borderFieldColorNLight;

    final Color textColor = showCorrect
        ? AppPalette.green
        : showWrong
        ? AppPalette.red
        : AppPalette.greyMedium;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.h(0.006),
          horizontal: SizeConfig.w(0.022),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            CustomTextWidget(
              "${option.letter}.",
              color: textColor,
              fontFamily: AppFont.elMessiriMedium,
              fontSize: SizeConfig.text(0.035),
            ),
            SizedBox(width: SizeConfig.w(0.015)),
            CustomTextWidget(
              option.text,
              textAlign: TextAlign.end,
              color: textColor,
              fontFamily: AppFont.elMessiriMedium,
              fontSize: SizeConfig.text(0.03),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
