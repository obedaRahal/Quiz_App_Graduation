import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';

class ReportReasonUiModel {
  final String label;

  const ReportReasonUiModel({required this.label});
}

void showReportReasonDialog({
  required BuildContext context,
  required String title,
  required List<ReportReasonUiModel> reasons,
  required void Function(ReportReasonUiModel reason, String description)
  onSubmit,
  String descriptionTitle = 'وصف المشكلة',
  String descriptionHint = 'صف لنا المشكلة بطريقة مختصرة وواضحة',
  String buttonText = 'تأكيد وإرسال الإبلاغ',
  int maxLength = 250,
  required DetailsOfTestCubit cubit,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'إغلاق نافذة الإبلاغ',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.18),
                ),
              ),
            ),
            Center(
              child: BlocProvider.value(
                value: cubit,
                child: BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
                  listenWhen: (previous, current) =>
                      previous.submitReportStatus != current.submitReportStatus,
                  listener: (context, state) {
                    if (state.isSubmitReportSuccess) {
                      Navigator.of(dialogContext).pop();

                      showValidationTopSnackBar(
                        context,
                        title: state.errorTitle ?? "تم بنجاح",
                        message: state.errorMessage ?? "تم إرسال البلاغ بنجاح",
                        type: AppValidationSnackBarType.success,
                      );

                      cubit.resetSubmitReportState();
                    }

                    if (state.isSubmitReportFailure) {
                      showValidationTopSnackBar(
                        context,
                        title: state.errorTitle ?? "خطأ",
                        message: state.errorMessage ?? "تعذر إرسال البلاغ",
                        type: AppValidationSnackBarType.error,
                      );

                      cubit.resetSubmitReportState();
                    }
                  },
                  builder: (context, state) {
                    return ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.92,
                        end: 1.0,
                      ).animate(curvedAnimation),
                      child: ReportReasonDialogCard(
                        title: title,
                        reasons: reasons,
                        descriptionTitle: descriptionTitle,
                        descriptionHint: descriptionHint,
                        buttonText: buttonText,
                        maxLength: maxLength,
                        isLoading: state.isSubmitReportLoading,
                        onSubmit: onSubmit,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class ReportReasonDialogCard extends StatefulWidget {
  final String title;
  final List<ReportReasonUiModel> reasons;
  final String descriptionTitle;
  final String descriptionHint;
  final String buttonText;
  final int maxLength;
  final void Function(ReportReasonUiModel reason, String description) onSubmit;
  final bool isLoading;

  const ReportReasonDialogCard({
    super.key,
    required this.title,
    required this.reasons,
    required this.onSubmit,
    this.descriptionTitle = 'وصف المشكلة',
    this.descriptionHint = 'صف لنا المشكلة بطريقة مختصرة وواضحة',
    this.buttonText = 'تأكيد وإرسال الإبلاغ',
    this.maxLength = 250,
    this.isLoading = false,
  });

  @override
  State<ReportReasonDialogCard> createState() => _ReportReasonDialogCardState();
}

class _ReportReasonDialogCardState extends State<ReportReasonDialogCard> {
  ReportReasonUiModel? selectedReason;
  String description = '';

  bool get canSubmit => !widget.isLoading && selectedReason != null;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: SizeConfig.w(0.86),
          constraints: BoxConstraints(maxHeight: SizeConfig.h(0.82)),
          decoration: BoxDecoration(
            color: appColors.whiteToblack,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppPalette.borderFieldColorNDark
                  : AppPalette.greyBorderCart,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ReportSheetHeader(
                    title: widget.title,
                    onClose: () => Navigator.of(context).pop(),
                  ),

                  CustomDivider(height: 2, thickness: 4, isDashed: true , dashWidth: 10,),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.035),
                      vertical: SizeConfig.h(0.018),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.reasons.map((reason) {
                          final isSelected =
                              selectedReason?.label == reason.label;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.h(0.01),
                            ),
                            child: _ReportReasonOption(
                              title: reason.label,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() => selectedReason = reason);
                              },
                            ),
                          );
                        }),

                        SizedBox(height: SizeConfig.h(0.01)),

                        CustomTextWidget(
                          widget.descriptionTitle,
                          color: appColors.blackTogreyMedium,
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.038),
                        ),

                        SizedBox(height: SizeConfig.h(0.01)),

                        TextField(
                          maxLength: widget.maxLength,
                          maxLines: 4,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          onChanged: (value) {
                            setState(() => description = value);
                          },
                          decoration: InputDecoration(
                            counterText:
                                '${description.length}/${widget.maxLength}',
                            hintText: widget.descriptionHint,
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(
                              color: AppPalette.greyMedium,
                              fontFamily: AppFont.elMessiriRegular,
                              fontSize: SizeConfig.text(0.03),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(0.04)
                                : AppPalette.grey,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.03),
                              vertical: SizeConfig.h(0.012),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppPalette.borderFieldColorNDark
                                    : AppPalette.borderFieldColorNLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppPalette.borderFieldColorNDark
                                    : AppPalette.borderFieldColorNLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: appColors.primaryToPrimaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  CustomDivider(height: 1, thickness: 1),

                  CustomBackgroundWithChild(
                    childVerticalPad: SizeConfig.h(0.01),
                    childHorizontalPad: SizeConfig.w(0.03),
                    backgroundColor: appColors.whiteToblack,
                    width: double.infinity,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppPalette.greyMediumDark
                            : AppPalette.greyBorderCart,
                        blurRadius: 4,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    //border: ,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        // horizontal: SizeConfig.w(0.025),
                        //vertical: SizeConfig.h(0.014),
                      ),
                      child: CustomButtonWidget(
                        width: double.infinity,
                        backgroundColor: canSubmit
                            ? appColors.primaryToPrimaryDark
                            : appColors.greyToGreyMediumDark,
                        borderRadius: 8,
                        childVerticalPad: SizeConfig.h(0.012),
                        onTap: canSubmit
                            ? () {
                                widget.onSubmit(
                                  selectedReason!,
                                  description.trim(),
                                );
                              }
                            : () {},
                        child: widget.isLoading
                            ? SizedBox(
                                width: SizeConfig.w(0.045),
                                height: SizeConfig.w(0.045),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: appColors.primaryToPrimaryDark,
                                ),
                              )
                            : CustomTextWidget(
                                widget.buttonText,
                                color: canSubmit
                                    ? appColors.whiteToblack
                                    : AppPalette.greyMedium,
                                fontFamily: AppFont.elMessiriSemiBold,
                                fontSize: SizeConfig.text(0.032),
                              ),
                        //   child: CustomTextWidget(
                        //     widget.buttonText,
                        //     color: canSubmit
                        //         ? AppPalette.white
                        //         : AppPalette.greyMedium,
                        //     fontFamily: AppFont.elMessiriSemiBold,
                        //     fontSize: SizeConfig.text(0.032),
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _ReportSheetHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.012),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: CustomTextWidget(
              title,
              color: appColors.blackToGrey2Dark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onClose,
              child: Container(
                padding: EdgeInsets.all(SizeConfig.w(0.015)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPalette.greyMedium),
                  //  boxShadow: [
                  //   BoxShadow(
                  //     color: AppPalette.grey2Dark,
                  //     blurRadius: 4
                  //   )
                  // ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: appColors.blackToGrey2Dark,
                  size: SizeConfig.h(0.024),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportReasonOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReportReasonOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(7),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.01),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.primarySoftTogreyLightDark
              : appColors.greyToGreyMediumDark,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
        ),

        child: CustomTextWidget(
          title,
          color: isSelected
              ? appColors.primaryToPrimaryDark
              : AppPalette.greyMedium,
          textAlign: TextAlign.right,
          fontFamily: isSelected
              ? AppFont.elMessiriSemiBold
              : AppFont.elMessiriRegular,
          fontSize: SizeConfig.text(0.03),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
