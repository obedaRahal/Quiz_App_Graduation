import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestSampleQuestionsSection extends StatelessWidget {
  const CreateTestSampleQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.isPublished != current.isPublished ||
            previous.questions.length != current.questions.length ||
            previous.selectedSampleQuestions !=
                current.selectedSampleQuestions ||
            previous.isEditMode != current.isEditMode;
      },
      builder: (context, state) {
        if (!state.isPublished ||
            state.questions.length < CreateTestCubit.minQuestionsCount) {
          return const SizedBox.shrink();
        }

        final allowedSamplesCount = _calculateAllowedSamplesCount(
          state.questions.length,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SampleHeader(isEditMode: state.isEditMode),

            SizedBox(height: SizeConfig.h(0.014)),

            if (state.selectedSampleQuestions.isNotEmpty) ...[
              Wrap(
                spacing: SizeConfig.w(0.018),
                runSpacing: SizeConfig.h(0.008),
                alignment: WrapAlignment.end,
                children: state.selectedSampleQuestions.map((index) {
                  return _SampleChip(title: 'السؤال # ${index + 1}');
                }).toList(),
              ),

              SizedBox(height: SizeConfig.h(0.012)),
            ],

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  showSampleQuestionsPicker(
                    context: context,
                    allowedSamplesCount: allowedSamplesCount,
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: SizeConfig.h(0.03),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(0.025),
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.greyMediumDark
                        : AppPalette.whiteToGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        'اختر عينة أسئلة',
                        fontSize: SizeConfig.text(0.024),
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppPalette.grey2Dark
                            : AppPalette.greyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: SizeConfig.w(0.006)),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: SizeConfig.text(0.038),
                        color: isDark
                            ? AppPalette.titleWhiteINDark
                            : AppPalette.greyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static int _calculateAllowedSamplesCount(int totalQuestions) {
    if (totalQuestions < CreateTestCubit.minQuestionsCount) return 0;

    final count = (totalQuestions * 0.10).ceil();

    if (count < 1) return 1;
    if (count > totalQuestions) return totalQuestions;

    return count;
  }
}

Future<void> showSampleQuestionsPicker({
  required BuildContext context,
  required int allowedSamplesCount,
}) {
  final cubit = context.read<CreateTestCubit>();
  final questions = cubit.state.questions;

  final initialSelected = cubit.state.selectedSampleQuestions
      .where((index) => index >= 0 && index < questions.length)
      .take(allowedSamplesCount)
      .toList();

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'sample_questions_picker',
    barrierColor: Colors.black.withOpacity(0.18),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final tempSelected = [...initialSelected];
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
              child: const SizedBox.expand(),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: SizeConfig.h(0.78)),
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.vertical(
                  //     top: Radius.circular(24),
                  //   ),
                  // ),
                  decoration: BoxDecoration(
                    color: isDark ? AppPalette.black : AppPalette.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border.all(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : Colors.transparent,
                    ),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      final selectedCount = tempSelected.length;
                      final canSave = selectedCount == allowedSamplesCount;
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final appColors = context.appColors;
                      return Column(
                        children: [
                          SizedBox(height: SizeConfig.h(0.010)),

                          Container(
                            width: SizeConfig.w(0.13),
                            height: SizeConfig.h(0.0045),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppPalette.greyLightDark
                                  : AppPalette.smallContainerGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),

                          SizedBox(height: SizeConfig.h(0.008)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.04),
                            ),
                            child: SizedBox(
                              height: SizeConfig.h(0.046),
                              width: double.infinity,
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.w(0.16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: SizeConfig.h(0.026),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.w(0.020),
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppPalette.fieldColorNDark
                                              : AppPalette.primarySoft,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: isDark
                                                ? AppPalette
                                                      .borderFieldColorNDark
                                                : appColors
                                                      .primaryToPrimaryDark,
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomTextWidget(
                                            '$selectedCount/$allowedSamplesCount',
                                            fontSize: SizeConfig.text(0.024),
                                            fontWeight: FontWeight.w900,
                                            color:
                                                appColors.primaryToPrimaryDark,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Center(
                                      child: CustomTextWidget(
                                        'عينة الأسئلة',
                                        fontSize: SizeConfig.text(0.040),
                                        fontWeight: FontWeight.w900,
                                        color: isDark
                                            ? AppPalette.textWhiteINDark
                                            : AppPalette.textColorInHome,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: SizeConfig.w(0.16)),
                                ],
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: SizeConfig.w(0.04),
                          //   ),
                          //   child: SizedBox(
                          //     height: SizeConfig.h(0.046),
                          //     child: Stack(
                          //       alignment: Alignment.center,
                          //       children: [
                          //         Center(
                          //           child: CustomTextWidget(
                          //             'عينة الأسئلة',
                          //             fontSize: SizeConfig.text(0.040),
                          //             fontWeight: FontWeight.w900,
                          //             color: AppPalette.textColorInHome,
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),

                          //         Align(
                          //           alignment: Alignment.centerLeft,
                          //           child: Container(
                          //             height: SizeConfig.h(0.026),
                          //             padding: EdgeInsets.symmetric(
                          //               horizontal: SizeConfig.w(0.030),
                          //             ),
                          //             decoration: BoxDecoration(
                          //               color: const Color(0xFFEAF1FF),
                          //               borderRadius: BorderRadius.circular(20),
                          //               border: Border.all(
                          //                 color: const Color(0xFF8FB4FF),
                          //               ),
                          //             ),
                          //             child: Center(
                          //               child: CustomTextWidget(
                          //                 '$selectedCount/$allowedSamplesCount',
                          //                 fontSize: SizeConfig.text(0.022),
                          //                 fontWeight: FontWeight.w900,
                          //                 color: const Color(0xFF5B86FF),
                          //                 textAlign: TextAlign.center,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          const _DashedDivider(),

                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.w(0.035),
                                vertical: SizeConfig.h(0.014),
                              ),
                              itemCount: questions.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: SizeConfig.h(0.010));
                              },
                              itemBuilder: (context, index) {
                                final question = questions[index];
                                final isSelected = tempSelected.contains(index);
                                final isMaxReached =
                                    tempSelected.length >= allowedSamplesCount;

                                return _SampleQuestionTile(
                                  questionNumber: index + 1,
                                  questionText: question.questionText,
                                  isSelected: isSelected,
                                  canSelect: isSelected || !isMaxReached,
                                  onTap: () {
                                    setModalState(() {
                                      if (isSelected) {
                                        tempSelected.remove(index);
                                        return;
                                      }

                                      if (tempSelected.length <
                                          allowedSamplesCount) {
                                        tempSelected.add(index);
                                        tempSelected.sort();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig.w(0.04),
                              right: SizeConfig.w(0.04),
                              top: SizeConfig.h(0.010),
                              bottom: SizeConfig.h(0.014),
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppPalette.black
                                  : AppPalette.white,
                              border: Border(
                                top: BorderSide(
                                  color: isDark
                                      ? AppPalette.borderFieldColorNDark
                                      : AppPalette.borderFieldColorNLight,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isDark ? 0.22 : 0.06,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: SizeConfig.h(0.048),
                              child: ElevatedButton(
                                onPressed: canSave
                                    ? () {
                                        cubit.setSelectedSampleQuestions(
                                          tempSelected,
                                        );
                                        Navigator.of(dialogContext).pop();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      appColors.primaryToPrimaryDark,
                                  disabledBackgroundColor: isDark
                                      ? AppPalette.greyLightDark
                                      : AppPalette.whiteToGrey,
                                  foregroundColor: AppPalette.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                // style: ElevatedButton.styleFrom(
                                //   backgroundColor: const Color(0xFF5B86FF),
                                //   disabledBackgroundColor: const Color(
                                //     0xFFEFEFEF,
                                //   ),
                                //   foregroundColor: Colors.white,
                                //   elevation: 0,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(7),
                                //   ),
                                // ),
                                child: CustomTextWidget(
                                  'حفظ',
                                  fontSize: SizeConfig.text(0.030),
                                  fontWeight: FontWeight.w900,
                                  color: canSave
                                      ? (isDark
                                            ? AppPalette.black
                                            : AppPalette.white)
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
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(opacity: curvedAnimation, child: child),
      );
    },
  );
}

class _SampleQuestionTile extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final bool isSelected;
  final bool canSelect;
  final VoidCallback onTap;

  const _SampleQuestionTile({
    required this.questionNumber,
    required this.questionText,
    required this.isSelected,
    required this.canSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    final cardColor = isDark ? AppPalette.fieldColorNDark : AppPalette.white;

    final borderColor = isSelected
        ? appColors.primaryToPrimaryDark
        : (isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight);

    final questionTextColor = isDark
        ? AppPalette.textWhiteINDark
        : AppPalette.textColorInHome;

    return Opacity(
      opacity: canSelect ? 1 : 0.55,
      child: InkWell(
        onTap: canSelect ? onTap : null,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.030),
            vertical: SizeConfig.h(0.012),
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: borderColor, width: isSelected ? 1.2 : 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.14 : 0.025),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          'السؤال ',
                          fontSize: SizeConfig.text(0.03),
                          fontWeight: FontWeight.w900,
                          color: appColors.primaryToPrimaryDark,
                          textAlign: TextAlign.right,
                        ),
                        CustomTextWidget(
                          '#$questionNumber',
                          fontSize: SizeConfig.text(0.03),
                          fontWeight: FontWeight.w900,
                          color: AppPalette.purple,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.h(0.004)),

                    CustomTextWidget(
                      questionText,
                      fontSize: SizeConfig.text(0.027),
                      fontWeight: FontWeight.w700,
                      color: questionTextColor,
                      textAlign: TextAlign.right,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.w(0.025)),
              _SampleCheckBox(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _SampleCheckBox extends StatelessWidget {
  final bool isSelected;

  const _SampleCheckBox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      width: SizeConfig.w(0.033),
      height: SizeConfig.w(0.033),
      margin: EdgeInsets.only(top: SizeConfig.h(0.002)),
      decoration: BoxDecoration(
        color: isSelected
            ? appColors.primaryToPrimaryDark
            : (isDark ? AppPalette.fieldColorNDark : AppPalette.white),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: isSelected
              ? appColors.primaryToPrimaryDark
              : (isDark
                    ? AppPalette.grey2Dark
                    : appColors.primaryToPrimaryDark),
          width: 1.2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check_rounded,
              size: SizeConfig.text(0.022),
              color: isDark ? AppPalette.black : AppPalette.white,
            )
          : null,
    );
  }
}

class _SampleHeader extends StatelessWidget {
  final bool isEditMode;

  const _SampleHeader({required this.isEditMode});

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
              path: AppImage.gridList,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
            ),
            SizedBox(width: SizeConfig.w(0.018)),
            CustomTextWidget(
              'عينة من الأسئلة',
              fontSize: SizeConfig.text(0.043),
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.004)),
        CustomTextWidget(
          isEditMode
              ? 'يمكنك تعديل عينة الأسئلة التي تظهر للمستخدمين قبل المشاركة في الاختبار.'
              : 'قم بتحديد عينة من الأسئلة ليتمكن المستخدمون من مطالعة المحتوى قبل المشاركة في هذه الجلسة بشكل مختصر',
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

class _SampleChip extends StatelessWidget {
  final String title;

  const _SampleChip({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Container(
      height: SizeConfig.h(0.030),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : appColors.primaryToPrimaryDark,
        ),
      ),
      child: Align(
        widthFactor: 1,
        heightFactor: 1,
        alignment: Alignment.center,
        child: CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.024),
          fontWeight: FontWeight.w800,
          color: appColors.primaryToPrimaryDark,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }
}

// class _SampleChip extends StatelessWidget {
//   final String title;

//   const _SampleChip({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final appColors = context.appColors;

//     return Container(
//       height: SizeConfig.h(0.030),
//       padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
//       decoration: BoxDecoration(
//         color: isDark ? AppPalette.fieldColorNDark : AppPalette.primarySoft,
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(
//           color: isDark
//               ? AppPalette.borderFieldColorNDark
//               : appColors.primaryToPrimaryDark,
//         ),
//       ),
//       child: CustomTextWidget(
//         title,
//         fontSize: SizeConfig.text(0.024),
//         fontWeight: FontWeight.w800,
//         color: appColors.primaryToPrimaryDark,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.greyMedium,
        ),
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
