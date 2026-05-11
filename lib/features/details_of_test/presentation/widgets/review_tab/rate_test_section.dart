import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';

class RateTestSection extends StatelessWidget {
  final int testId;
  final bool canSubmitReview;
  final ReviewFormMode mode;
  final VoidCallback? onCancelEdit;

  const RateTestSection({
    super.key,
    required this.testId,
    required this.canSubmitReview,
    this.mode = ReviewFormMode.create,
    this.onCancelEdit,
  });

  static const int maxChars = 200;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return BlocListener<DetailsOfTestCubit, DetailsOfTestState>(
      listenWhen: (previous, current) =>
          previous.addReviewStatus != current.addReviewStatus,
      listener: (context, state) {
        if (state.isAddReviewSuccess) {
          showValidationTopSnackBar(
            context,
            title: "تم بنجاح",
            message: "تم نشر تقييمك بنجاح",
            type: AppValidationSnackBarType.success,
          );

          context.read<DetailsOfTestCubit>().resetAddReviewState();
        }

        if (state.isAddReviewFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر نشر التقييم",
            type: AppValidationSnackBarType.error,
          );

          context.read<DetailsOfTestCubit>().resetAddReviewState();
        }
      },
      child: BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
        buildWhen: (previous, current) =>
            previous.draftReviewRating != current.draftReviewRating ||
            previous.draftReviewText != current.draftReviewText ||
            previous.addReviewStatus != current.addReviewStatus ||
            previous.updateReviewStatus != current.updateReviewStatus ||
            previous.isEditingMyReview != current.isEditingMyReview,
        builder: (context, state) {
          final currentLength = state.draftReviewText.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Row(
              //   textDirection: TextDirection.rtl,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CustomTextWidget(
              //       "قيم الاختبار",
              //       color: appColors.blackTogreyMedium,
              //       fontFamily: AppFont.elMessiriBold,
              //       fontSize: SizeConfig.text(0.04),
              //     ),

              //     CustomButtonWidget(
              //       backgroundColor: state.canSubmitDraftReview
              //           ? appColors.primaryToPrimaryDark
              //           : appColors.greyMediumTogrey,
              //       childHorizontalPad: SizeConfig.w(0.06),
              //       childVerticalPad: SizeConfig.w(0.01),
              //       borderRadius: 18,
              //       onTap: state.canSubmitDraftReview
              //           ? () {
              //               // context.read<DetailsOfTestCubit>().submitDraftReview(
              //               //   testId: testId,
              //               // );
              //               if (!canSubmitReview) {
              //                 showValidationTopSnackBar(
              //                   context,
              //                   title: "تنبيه",
              //                   message:
              //                       "يجب شراء الاختبار أولًا حتى تتمكن من نشر تقييمك",
              //                   type: AppValidationSnackBarType.hint,
              //                 );
              //                 return;
              //               }

              //               context
              //                   .read<DetailsOfTestCubit>()
              //                   .submitDraftReview(testId: testId);
              //             }
              //           : () {
              //               showValidationTopSnackBar(
              //                 context,
              //                 title: "تنبيه",
              //                 message: "اختر عدد النجوم أولًا",
              //                 type: AppValidationSnackBarType.error,
              //               );
              //             },
              //       child: state.isAddReviewLoading
              //           ? SizedBox(
              //               width: SizeConfig.w(0.045),
              //               height: SizeConfig.w(0.045),
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2.5,
              //                 color: appColors.whiteToblack,
              //               ),
              //             )
              //           : CustomTextWidget(
              //               "نشر",
              //               color: appColors.whiteToblack,
              //               fontSize: SizeConfig.text(0.03),
              //             ),
              //     ),
              //   ],
              // ),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      CustomTextWidget(
                        mode == ReviewFormMode.edit
                            ? "تعديل تقييمك"
                            : "قيم الاختبار",
                        color: appColors.blackTogreyMedium,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.04),
                      ),

                      if (mode == ReviewFormMode.edit) ...[
                        SizedBox(width: SizeConfig.w(0.02)),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: onCancelEdit,
                          child: Icon(
                            Icons.close_rounded,
                            color: AppPalette.red,
                            size: SizeConfig.h(0.028),
                          ),
                        ),
                      ],
                    ],
                  ),

                  CustomButtonWidget(
                    backgroundColor: state.canSubmitDraftReview
                        ? appColors.primaryToPrimaryDark
                        : appColors.greyMediumTogrey,
                    childHorizontalPad: SizeConfig.w(0.06),
                    childVerticalPad: SizeConfig.w(0.01),
                    borderRadius: 18,
                    onTap:
                        state.isAddReviewLoading || state.isUpdateReviewLoading
                        ? () {}
                        : () {
                            if (!canSubmitReview) {
                              showValidationTopSnackBar(
                                context,
                                title: "تنبيه",
                                message:
                                    "يجب شراء الاختبار أولًا حتى تتمكن من نشر تقييمك",
                                type: AppValidationSnackBarType.hint,
                              );
                              return;
                            }

                            if (state.draftReviewRating <= 0) {
                              showValidationTopSnackBar(
                                context,
                                title: "تنبيه",
                                message: "اختر عدد النجوم أولًا",
                                type: AppValidationSnackBarType.error,
                              );
                              return;
                            }

                            if (state.draftReviewText.trim().isEmpty) {
                              showValidationTopSnackBar(
                                context,
                                title: "تنبيه",
                                message: "اكتب تعليقك قبل النشر",
                                type: AppValidationSnackBarType.error,
                              );
                              return;
                            }

                            if (mode == ReviewFormMode.edit) {
                              context.read<DetailsOfTestCubit>().updateMyReview(
                                testId: testId,
                              );
                            } else {
                              context.read<DetailsOfTestCubit>().addTestReview(
                                testId: testId,
                                rating: state.draftReviewRating,
                                reviewText: state.draftReviewText,
                              );
                            }
                          },
                    child:
                        state.isAddReviewLoading || state.isUpdateReviewLoading
                        ? SizedBox(
                            width: SizeConfig.w(0.045),
                            height: SizeConfig.w(0.045),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: appColors.whiteToblack,
                            ),
                          )
                        : CustomTextWidget(
                            mode == ReviewFormMode.edit ? "حفظ" : "نشر",
                            color: appColors.whiteToblack,
                            fontSize: SizeConfig.text(0.03),
                          ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(0.004)),

              CustomTextWidget(
                "أخبر الآخرين ما هو انطباعك",
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.03),
              ),

              SizedBox(height: SizeConfig.h(0.005)),

              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final isSelected = starValue <= state.draftReviewRating;

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<DetailsOfTestCubit>()
                          .changeDraftReviewRating(starValue);
                    },
                    child: Icon(
                      isSelected
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: SizeConfig.h(0.072),
                      color: isSelected
                          ? AppPalette.yellow
                          : AppPalette.greyMedium,
                    ),
                  );
                }),
              ),

              SizedBox(height: SizeConfig.h(0.012)),

              SizedBox(
                height: 40,
                child:
                    //TextField(
                    TextFormField(
                      key: ValueKey(
                        '${state.isEditingMyReview}_${state.editingReviewId}',
                      ),
                      initialValue: state.draftReviewText,
                      maxLength: maxChars,
                      maxLines: 2,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      onChanged: context
                          .read<DetailsOfTestCubit>()
                          .changeDraftReviewText,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "اشرح تجربتك",
                        hintStyle: TextStyle(
                          color: AppPalette.greyMedium,
                          fontFamily: AppFont.elMessiriRegular,
                          fontSize: SizeConfig.text(0.032),
                        ),
                        filled: true,
                        fillColor: appColors.greyToGreyMediumDark,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.035),
                          vertical: SizeConfig.h(0.012),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(SizeConfig.h(0.02)),
                          child: FaIcon(
                            FontAwesomeIcons.masksTheater,
                            color: AppPalette.greyMedium,
                            size: SizeConfig.h(0.025),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: appColors
                                .borderFieldColorNLightToborderFieldColorNDark,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: appColors
                                .borderFieldColorNLightToborderFieldColorNDark,
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
              ),

              SizedBox(height: SizeConfig.h(0.003)),

              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextWidget(
                  "$currentLength/$maxChars",
                  color: currentLength >= maxChars
                      ? AppPalette.red
                      : AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.028),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
