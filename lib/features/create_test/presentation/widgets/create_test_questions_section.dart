import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_top_explanation_banner.dart';

class CreateTestQuestionsSection extends StatelessWidget {
  const CreateTestQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.questions != current.questions ||
            previous.creationMode != current.creationMode ||
            previous.aiProvider != current.aiProvider;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _QuestionsHeader(),

            SizedBox(height: SizeConfig.h(0.016)),
            if (state.isAiMode &&
                state.aiProvider.trim().isNotEmpty &&
                state.questions.isNotEmpty) ...[
              _AiProviderBanner(provider: state.aiProvider),
              SizedBox(height: SizeConfig.h(0.012)),
            ],
            if (state.questions.isNotEmpty) ...[
              ...List.generate(
                state.questions.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(0.012)),
                  child: _QuestionPreviewCard(
                    question: state.questions[index],
                    questionNumber: index + 1,
                    onEdit: () {
                      context.read<CreateTestCubit>().startEditingQuestion(
                        index,
                      );
                      showCreateQuestionDialog(context);
                    },
                    onDelete: () {
                      context.read<CreateTestCubit>().removeQuestion(index);
                    },
                  ),
                ),
              ),
            ],

            _AddQuestionRow(
              count: state.questions.length,
              onTap: state.questions.length >= CreateTestCubit.maxQuestionsCount
                  ? null
                  : () {
                      context.read<CreateTestCubit>().resetQuestionDraft();
                      showCreateQuestionDialog(context);
                    },
            ),
          ],
        );
      },
    );
  }
}

class _QuestionsHeader extends StatelessWidget {
  const _QuestionsHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppImage(
              path: AppImage.grid,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            CustomTextWidget(
              'الأسئلة',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.006)),
        CustomTextWidget(
          'قم بكتابة الأسئلة الخاصة بالاختبار، يمكنك إضافة من خيارين إلى خمس خيارات لكل سؤال وإجابة واحدة صحيحة فقط',
          fontSize: SizeConfig.text(0.033),
          fontWeight: FontWeight.w500,
          color: AppPalette.greyMedium,
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _AddQuestionRow extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _AddQuestionRow({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: SizeConfig.h(0.040),
              child: CustomPaint(
                painter: _DashedRoundedRectPainter(
                  color: isDisabled
                      ? AppPalette.greyMedium
                      : appColors.primaryToPrimaryDark,
                  radius: 8,
                  strokeWidth: 1.4,
                  dashWidth: 6,
                  dashSpace: 4,
                ),
                child: Center(
                  child: Icon(
                    Icons.add_rounded,
                    size: SizeConfig.text(0.050),
                    color: isDisabled
                        ? AppPalette.greyMedium
                        : appColors.primaryToPrimaryDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: SizeConfig.w(0.018)),

        Container(
          height: SizeConfig.h(0.040),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.030)),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.fieldColorNDark : AppPalette.purpleLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppPalette.purple),
          ),
          child: Center(
            child: CustomTextWidget(
              '${CreateTestCubit.maxQuestionsCount}/$count',
              fontSize: SizeConfig.text(0.03),
              fontWeight: FontWeight.w900,
              color: AppPalette.purple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionPreviewCard extends StatelessWidget {
  final CreateTestQuestionState question;
  final int questionNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionPreviewCard({
    required this.question,
    required this.questionNumber,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final cardColor = isDark ? AppPalette.fieldColorNDark : AppPalette.white;
    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : const Color(0xFFE6E6E6);
    final primaryTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;
    final secondaryTextColor = isDark
        ? AppPalette.titleWhiteINDark
        : AppPalette.borderFieldColorNDark;

    return Container(
      padding: EdgeInsets.all(SizeConfig.w(0.030)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomTextWidget(
                ' السؤال ',
                fontSize: SizeConfig.text(0.03),
                fontWeight: FontWeight.w900,
                color: appColors.primaryToPrimaryDark,
                textAlign: TextAlign.right,
              ),
              CustomTextWidget(
                "# $questionNumber",
                fontSize: SizeConfig.text(0.03),
                fontWeight: FontWeight.w900,
                color: AppPalette.purple,
                textAlign: TextAlign.right,
              ),
              const Spacer(),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                elevation: 4,
                position: PopupMenuPosition.under,
                constraints: BoxConstraints(
                  minWidth: SizeConfig.w(0.34),
                  maxWidth: SizeConfig.w(0.38),
                ),
                color: isDark ? AppPalette.greyMediumDark : AppPalette.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.greyMedium,
                    width: 1,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                    return;
                  }

                  if (value == 'delete') {
                    onDelete();
                    return;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      height: SizeConfig.h(0.036),
                      padding: EdgeInsets.zero,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: SizeConfig.w(0.34),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.030),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomTextWidget(
                                'تعديل السؤال',
                                fontSize: SizeConfig.text(0.028),
                                fontWeight: FontWeight.w600,
                                color: secondaryTextColor,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    PopupMenuItem<String>(
                      value: 'delete',
                      height: SizeConfig.h(0.036),
                      padding: EdgeInsets.zero,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: SizeConfig.w(0.34),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.030),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomTextWidget(
                                'حذف السؤال',
                                fontSize: SizeConfig.text(0.028),
                                fontWeight: FontWeight.w600,
                                color: AppPalette.red,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                child: Icon(
                  Icons.more_vert_rounded,
                  size: SizeConfig.text(0.050),
                  color: isDark
                      ? AppPalette.titleWhiteINDark
                      : const Color(0xFF8F8F8F),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          CustomTextWidget(
            question.questionText,
            fontSize: SizeConfig.text(0.042),
            fontWeight: FontWeight.w500,
            color: primaryTextColor,
            textAlign: TextAlign.right,
            maxLines: 3,
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          Row(
            children: [
              CustomTextWidget(
                'الخيارات',
                fontSize: SizeConfig.text(0.034),
                fontWeight: FontWeight.w500,
                color: appColors.primaryToPrimaryDark,
                textAlign: TextAlign.right,
              ),
              const Spacer(),
              if (question.explanation.trim().isNotEmpty)
                InkWell(
                  onTap: () {
                    showTopExplanationBanner(
                      context: context,
                      title: 'الشرح',
                      message: question.explanation,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      size: SizeConfig.text(0.050),
                      color: appColors.primaryToPrimaryDark,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          ...List.generate(question.options.length, (index) {
            final isCorrect = index == question.correctOptionIndex;

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.006)),
              child: _PreviewOptionTile(
                label: String.fromCharCode(65 + index),
                text: question.options[index],
                isCorrect: isCorrect,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PreviewOptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool isCorrect;

  const _PreviewOptionTile({
    required this.label,
    required this.text,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isCorrect
        ? (isDark
              ? AppPalette.correctAnswerDarkContainer
              : AppPalette.correctAnswerLightContainer)
        : (isDark
              ? AppPalette.greyMediumDark
              : AppPalette.answerLightContainer);

    final borderColor = isCorrect
        ? AppPalette.correctAnswerBorder
        : (isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight);

    final textColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.answerContainerText;

    final labelColor = isDark
        ? AppPalette.titleWhiteINDark
        : AppPalette.answerContainerText;

    return Container(
      constraints: BoxConstraints(minHeight: SizeConfig.h(0.038)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.020),
        vertical: SizeConfig.h(0.006),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomTextWidget(
              label,
              fontSize: SizeConfig.text(0.032),
              fontWeight: FontWeight.w600,
              color: labelColor,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.010)),

          Expanded(
            child: CustomTextWidget(
              text,
              fontSize: SizeConfig.text(0.032),
              fontWeight: FontWeight.w500,
              color: textColor,
              textAlign: TextAlign.right,
              maxLines: 3,
              //overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCreateQuestionDialog(BuildContext context) {
  final cubit = context.read<CreateTestCubit>();

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'create_question_dialog',
    barrierColor: Colors.black.withOpacity(0.22),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      return BlocProvider.value(
        value: cubit,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                child: const SizedBox.expand(),
              ),
            ),

            Center(
              child: Material(
                color: Colors.transparent,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: SizeConfig.w(0.92),
                    constraints: BoxConstraints(maxHeight: SizeConfig.h(0.86)),

                    decoration: BoxDecoration(
                      color: isDark ? AppPalette.black : AppPalette.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppPalette.borderFieldColorNDark
                            : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.28 : 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const _CreateQuestionDialogContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: 0.96 + (animation.value * 0.04),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _CreateQuestionDialogContent extends StatelessWidget {
  const _CreateQuestionDialogContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final appColors = context.appColors;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.035),
                vertical: SizeConfig.h(0.012),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: CustomTextWidget(
                      state.editingQuestionIndex == null
                          ? 'سؤال جديد'
                          : 'تعديل سؤال',
                      fontSize: SizeConfig.text(0.040),
                      fontWeight: FontWeight.w900,
                      color: isDark
                          ? AppPalette.textWhiteINDark
                          : AppPalette.textColorInHome,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: SizeConfig.w(0.080),
                        height: SizeConfig.w(0.080),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppPalette.fieldColorNDark
                              : AppPalette.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppPalette.borderFieldColorNDark
                                : AppPalette.primaryToWhite,
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: SizeConfig.text(0.040),
                          color: isDark
                              ? AppPalette.titleWhiteINDark
                              : AppPalette.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8),
              child: const _DashedDivider(),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.04),
                  vertical: SizeConfig.h(0.014),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DialogLabel('سؤال الاختبار'),

                    SizedBox(height: SizeConfig.h(0.008)),

                    _DialogTextField(
                      hintText: 'اطرح سؤالك...',
                      maxLength: CreateTestCubit.questionMaxLength,
                      currentLength: state.draftQuestionText.length,
                      initialValue: state.draftQuestionText,
                      onChanged: context
                          .read<CreateTestCubit>()
                          .changeDraftQuestionText,
                    ),

                    SizedBox(height: SizeConfig.h(0.018)),

                    _DialogLabel('خيارات الإجابة'),

                    SizedBox(height: SizeConfig.h(0.008)),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppPalette.fieldColorNDark
                            : AppPalette.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? AppPalette.borderFieldColorNDark
                              : AppPalette.borderFieldColorNLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          ...List.generate(state.draftOptions.length, (index) {
                            final option = state.draftOptions[index];
                            final isCorrect =
                                state.draftCorrectOptionIndex == index;

                            return _DraftOptionField(
                              index: index,
                              text: option.text,
                              isCorrect: isCorrect,
                            );
                          }),

                          if (state.draftOptions.length <
                              CreateTestCubit.maxOptionsCount)
                            InkWell(
                              onTap: context
                                  .read<CreateTestCubit>()
                                  .addDraftOption,
                              child: Container(
                                height: SizeConfig.h(0.040),
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.w(0.025),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add_circle_rounded,
                                      color: appColors.primaryToPrimaryDark,
                                      size: SizeConfig.text(0.040),
                                    ),
                                    SizedBox(width: SizeConfig.w(0.012)),
                                    CustomTextWidget(
                                      'إضافة خيار جديد',
                                      fontSize: SizeConfig.text(0.028),
                                      fontWeight: FontWeight.w800,
                                      color: appColors.primaryToPrimaryDark,

                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.004)),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomTextWidget(
                        '5/${state.draftOptions.length}',
                        fontSize: SizeConfig.text(0.028),
                        fontWeight: FontWeight.w600,
                        color: AppPalette.greyMedium,
                        textAlign: TextAlign.left,
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.018)),

                    _DialogLabel('شرح الإجابة'),

                    SizedBox(height: SizeConfig.h(0.005)),

                    CustomTextWidget(
                      'يمكنك إضافة شرح ليظهر للمتعلمين ، هذا الحقل اختياري.',
                      fontSize: SizeConfig.text(0.024),
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppPalette.grey2Dark
                          : const Color(0xFFB8B8B8),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                    ),

                    SizedBox(height: SizeConfig.h(0.008)),

                    _DialogTextField(
                      hintText: 'ضع شرحاً لإجابتك...',
                      maxLength: CreateTestCubit.explanationMaxLength,
                      currentLength: state.draftExplanation.length,
                      initialValue: state.draftExplanation,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: context
                          .read<CreateTestCubit>()
                          .changeDraftExplanation,
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 1,
              width: double.infinity,
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.borderFieldColorNLight,
            ),

            Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.04)),
              child: SizedBox(
                width: double.infinity,
                height: SizeConfig.h(0.050),
                child: ElevatedButton(
                  onPressed: state.canCreateDraftQuestion
                      ? () {
                          context.read<CreateTestCubit>().createDraftQuestion();
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryToPrimaryDark,
                    disabledBackgroundColor: isDark
                        ? AppPalette.greyLightDark
                        : AppPalette.whiteToGrey,
                    foregroundColor: AppPalette.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: CustomTextWidget(
                    state.editingQuestionIndex == null
                        ? 'إنشاء السؤال'
                        : 'تعديل السؤال',
                    fontSize: SizeConfig.text(0.04),
                    fontWeight: FontWeight.w800,
                    color: state.canCreateDraftQuestion
                        ? isDark
                              ? AppPalette.black
                              : AppPalette.white
                        : (isDark
                              ? AppPalette.grey2Dark
                              : AppPalette.greyMedium),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DialogLabel extends StatelessWidget {
  final String text;

  const _DialogLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomTextWidget(
      text,
      fontSize: SizeConfig.text(0.04),
      fontWeight: FontWeight.w900,
      color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,
      textAlign: TextAlign.right,
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final String hintText;
  final int maxLength;
  final int currentLength;
  final int minLines;
  final int maxLines;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _DialogTextField({
    required this.hintText,
    required this.maxLength,
    required this.currentLength,
    required this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
    this.initialValue = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final textColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    final hintColor = isDark ? AppPalette.grey2Dark : AppPalette.grey2;

    final fillColor = isDark ? AppPalette.fieldColorNDark : AppPalette.grey;

    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.borderFieldColorNLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: initialValue,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
          onChanged: onChanged,
          style: TextStyle(
            fontSize: SizeConfig.text(0.03),
            fontFamily: AppFont.elMessiriRegular,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          cursorColor: appColors.primaryToPrimaryDark,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
              fontSize: SizeConfig.text(0.03),
              fontWeight: FontWeight.w600,
              color: hintColor,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.030),
              vertical: SizeConfig.h(0.012),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: appColors.primaryToPrimaryDark,
                width: 1.2,
              ),
            ),
          ),
        ),

        SizedBox(height: SizeConfig.h(0.003)),

        Align(
          alignment: Alignment.centerLeft,
          child: CustomTextWidget(
            '$maxLength/$currentLength',
            fontSize: SizeConfig.text(0.028),
            fontWeight: FontWeight.w700,
            color: AppPalette.greyMedium,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _DraftOptionField extends StatelessWidget {
  final int index;
  final String text;
  final bool isCorrect;

  const _DraftOptionField({
    required this.index,
    required this.text,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final canRemove =
        context.read<CreateTestCubit>().state.draftOptions.length >
        CreateTestCubit.minOptionsCount;

    final borderColor = isDark
        ? AppPalette.borderFieldColorNDark
        : AppPalette.borderFieldColorNLight;

    final textColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    final hintColor = isDark ? AppPalette.grey2Dark : AppPalette.grey2;

    return Container(
      height: SizeConfig.h(0.052),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () =>
                context.read<CreateTestCubit>().selectDraftCorrectOption(index),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: SizeConfig.w(0.080),
              alignment: Alignment.center,
              child: Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isCorrect
                    ? AppPalette.correctAnswerBorder
                    : (isDark ? AppPalette.grey2Dark : const Color(0xFFCFCFCF)),
                size: SizeConfig.text(0.038),
              ),
            ),
          ),

          Expanded(
            child: TextFormField(
              initialValue: text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.center,
              maxLength: CreateTestCubit.optionMaxLength,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  CreateTestCubit.optionMaxLength,
                ),
              ],
              onChanged: (value) {
                context.read<CreateTestCubit>().changeDraftOptionText(
                  index: index,
                  value: value,
                );
              },
              style: TextStyle(
                fontSize: SizeConfig.text(0.03),
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: AppFont.elMessiriRegular,
                height: 1.0,
              ),
              cursorColor: context.appColors.primaryToPrimaryDark,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'خيار...',
                hintTextDirection: TextDirection.rtl,
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  top: SizeConfig.h(0.006),
                  bottom: SizeConfig.h(0.006),
                ),
                hintStyle: TextStyle(
                  fontSize: SizeConfig.text(0.03),
                  fontFamily: AppFont.elMessiriRegular,
                  fontWeight: FontWeight.w600,
                  color: hintColor,
                  height: 1.0,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: canRemove
                ? () => context.read<CreateTestCubit>().removeDraftOption(index)
                : null,
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: SizeConfig.w(0.070),
              child: Center(
                child: Icon(
                  Icons.close_rounded,
                  size: SizeConfig.text(0.036),
                  color: canRemove
                      ? (isDark
                            ? AppPalette.titleWhiteINDark
                            : AppPalette.greyLightDark)
                      : (isDark ? AppPalette.greyLightDark : AppPalette.grey3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(color: AppPalette.greyMedium),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    double x = 0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 9, 0), paint);
      x += 15;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _AiProviderBanner extends StatelessWidget {
  final String provider;

  const _AiProviderBanner({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.030),
        vertical: SizeConfig.h(0.010),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : appColors.primaryToPrimaryDark.withOpacity(0.35),
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: SizeConfig.w(0.075),
            height: SizeConfig.w(0.075),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppPalette.greyMediumDark : AppPalette.white,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: SizeConfig.text(0.044),
              color: appColors.primaryToPrimaryDark,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.020)),

          Expanded(
            child: CustomTextWidget(
              'تم توليد الأسئلة باستخدام الأداة $provider',
              fontSize: SizeConfig.text(0.030),
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rRect);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          (distance + dashWidth).clamp(0, metric.length),
        );

        canvas.drawPath(extractPath, paint);

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
