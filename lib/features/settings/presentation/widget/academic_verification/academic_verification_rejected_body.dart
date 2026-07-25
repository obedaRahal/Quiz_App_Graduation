import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/onboarding_image_picker_field.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_header.dart';

class AcademicVerificationRejectedBody extends StatelessWidget {
  final AcademicVerificationEntity verification;

  const AcademicVerificationRejectedBody({
    super.key,
    required this.verification,
  });

  Future<void> _pickImage(
    BuildContext context, {
    required void Function(String path) onPicked,
  }) async {
    final path = await sl<FilePickerService>().pickSingleImagePath();

    if (path == null || !context.mounted) {
      return;
    }

    onPicked(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AcademicVerificationCubit, AcademicVerificationState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AcademicVerificationHeader(),

                    const SizedBox(height: 26),

                    CustomBackgroundWithChild(
                      width: double.infinity,
                      padding: EdgeInsets.all(SizeConfig.h(0.01)),
                      backgroundColor: AppPalette.red.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppPalette.red),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: AppPalette.red,
                              ),
                              const SizedBox(width: 10),
                              CustomTextWidget(
                                'تم رفض طلب التوثيق',
                                fontWeight: FontWeight.w700,
                                color: AppPalette.red,
                                fontSize: SizeConfig.text(0.045),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextWidget(
                                verification.rejectionReason ??
                                    'لم يتم تحديد سبب الرفض.',
                                color: AppPalette.red,
                                fontSize: SizeConfig.text(0.035),
                              ),

                              const SizedBox(height: 5),

                              CustomTextWidget(
                                'سبب الرفض : ',
                                fontWeight: FontWeight.w700,
                                color: AppPalette.red,
                                fontSize: SizeConfig.text(0.035),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextWidget(
                                verification.submittedAt ?? 'غير متوفر',
                                color: AppPalette.red,
                                fontSize: SizeConfig.text(0.035),
                              ),

                              const SizedBox(height: 5),

                              CustomTextWidget(
                                'تاريخ تقديم الطلب : ',
                                fontWeight: FontWeight.w700,
                                color: AppPalette.red,
                                fontSize: SizeConfig.text(0.035),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.025)),

                    SizedBox(
                      width: double.infinity,
                      child: CustomTextWidget(
                        'تاريخ تقديم الطلب: ',
                        color: context.appColors.blackToGrey2Dark,
                        fontSize: SizeConfig.text(0.05),
                        fontFamily: AppFont.elMessiriBold,
                        textAlign: TextAlign.right,
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.01)),

                    SizedBox(
                      width: double.infinity,
                      child: CustomTextWidget(
                        'تأكد من أن الصور واضحة وكاملة قبل إعادة إرسال الطلب.',
                        color: context.appColors.blackTogreyMedium,
                        fontSize: SizeConfig.text(0.04),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    const SizedBox(height: 22),

                    OnboardingImagePickerField(
                      title: 'الشهادة الجامعية',
                      hintText: 'يرجى إرفاق شهادتك الجامعية...',
                      imagePath: state.certificateImagePath,
                      onTap: () {
                        _pickImage(
                          context,
                          onPicked: (path) {
                            context
                                .read<AcademicVerificationCubit>()
                                .certificateImageChanged(path);
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 22),

                    OnboardingImagePickerField(
                      title: 'الهوية الشخصية',
                      hintText: 'يرجى إرفاق الوجه الأمامي للهوية الشخصية...',
                      imagePath: state.identityImagePath,
                      onTap: () {
                        _pickImage(
                          context,
                          onPicked: (path) {
                            context
                                .read<AcademicVerificationCubit>()
                                .identityImageChanged(path);
                          },
                        );
                      },
                    ),
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
                backgroundColor: state.canSubmitRequest
                    ? context.appColors.primaryToPrimaryDark
                    : AppPalette.greyBorderCart,
                childHorizontalPad: SizeConfig.w(0.04),
                childVerticalPad: SizeConfig.w(0.013),
                borderRadius: 6,
                onTap: state.canSubmitRequest
                    ? () async {
                        debugPrint(
                          '============ AcademicVerificationNoRequestBody.submit ============',
                        );
                        debugPrint(
                          '→ certificateImagePath: ${state.certificateImagePath}',
                        );
                        debugPrint(
                          '→ identityImagePath: ${state.identityImagePath}',
                        );
                        debugPrint(
                          '→ canSubmitRequest: ${state.canSubmitRequest}',
                        );

                        final isSuccess = await context
                            .read<AcademicVerificationCubit>()
                            .submitRequest();

                        debugPrint('→ isSuccess: $isSuccess');
                        debugPrint(
                          '==================================================================',
                        );
                      }
                    : () {},
                child: state.isSubmitLoading
                    ? SizedBox(
                        width: SizeConfig.w(0.05),
                        height: SizeConfig.w(0.05),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Padding(
                        padding: EdgeInsets.all(SizeConfig.h(0.008)),
                        child: CustomTextWidget(
                          'طلب تأكيد المستوى العلمي',
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
