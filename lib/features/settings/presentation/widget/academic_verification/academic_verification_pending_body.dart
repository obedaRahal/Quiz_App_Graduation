import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_header.dart';

class AcademicVerificationPendingBody extends StatelessWidget {
  final AcademicVerificationEntity verification;

  const AcademicVerificationPendingBody({
    super.key,
    required this.verification,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AcademicVerificationCubit, AcademicVerificationState>(
      builder: (context, state) {
        final canCancel =
            verification.remainingCancellations > 0 && !state.isCancelLoading;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const AcademicVerificationHeader(),

                    SizedBox(height: SizeConfig.h(0.03)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          size: SizeConfig.h(0.03),
                          color: theme.colorScheme.primary,
                        ),

                        CustomTextWidget(
                          'طلبك قيد المراجعة',
                          color: context.appColors.blackTogreyMedium,
                          fontFamily: AppFont.elMessiriBold,
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.h(0.005)),

                    SizedBox(
                      width: double.infinity,
                      child: CustomTextWidget(
                        'تم استلام طلب تأكيد المستوى العلمي، '
                        'وسيتم إشعارك بعد مراجعته.',
                        textAlign: TextAlign.right,
                        color: context.appColors.blackTogreyMedium,
                        fontSize: SizeConfig.text(0.04),
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.03)),

                    _InformationRow(
                      title: 'تاريخ تقديم الطلب',
                      value: verification.submittedAt ?? 'غير متوفر',
                    ),

                    SizedBox(height: SizeConfig.h(0.02)),

                    _InformationRow(
                      title: 'مرات الإلغاء المتبقية',
                      value:
                          '${verification.remainingCancellations} '
                          'من أصل 2',
                    ),

                    SizedBox(height: SizeConfig.h(0.03)),
                  ],
                ),
              ),
            ),

            CustomBackgroundWithChild(
              childVerticalPad: SizeConfig.h(0.015),
              childHorizontalPad: SizeConfig.w(0.03),
              backgroundColor: context.appColors.whiteToblack,
              width: double.infinity,
              boxShadow: const [
                BoxShadow(
                  color: AppPalette.greyBorderCart,
                  blurRadius: 4,
                  offset: Offset(0, -4),
                ),
              ],
              child: CustomButtonWidget(
                width: double.infinity,
                backgroundColor: canCancel
                    ? AppPalette.red
                    : AppPalette.greyBorderCart,
                childHorizontalPad: SizeConfig.w(0.04),
                childVerticalPad: SizeConfig.w(0.013),
                borderRadius: 6,
                onTap: canCancel
                    ? () async {
                        debugPrint(
                          '============ AcademicVerificationPendingBody.cancel ============',
                        );
                        debugPrint(
                          '→ remainingCancellations: '
                          '${verification.remainingCancellations}',
                        );

                        final isSuccess = await context
                            .read<AcademicVerificationCubit>()
                            .cancelRequest();

                        debugPrint('→ isSuccess: $isSuccess');
                        debugPrint(
                          '================================================================',
                        );
                      }
                    : () {},
                child: state.isCancelLoading
                    ? SizedBox(
                        width: SizeConfig.w(0.05),
                        height: SizeConfig.w(0.05),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.appColors.whiteToblack,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(SizeConfig.h(0.008)),
                        child: CustomTextWidget(
                          verification.remainingCancellations > 0
                              ? 'إلغاء طلب التوثيق'
                              : 'لا توجد مرات إلغاء متبقية',
                          fontSize: SizeConfig.text(0.03),
                          color: context.appColors.whiteToblack,
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

class _InformationRow extends StatelessWidget {
  final String title;
  final String value;

  const _InformationRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomBackgroundWithChild(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.015),
      ),
      border: Border.all(
        color: context.appColors.borderFieldColorNLightToborderFieldColorNDark,
      ),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: context.appColors.greyToGreyMediumDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          CustomTextWidget(
            value,
            textAlign: TextAlign.right,
            color: context.appColors.primaryToPrimaryDark,
            fontSize: SizeConfig.text(0.04),
            fontFamily: AppFont.elMessiriSemiBold,
          ),

          Text(title, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
