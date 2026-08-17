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

class AcademicVerificationNoRequestBody extends StatelessWidget {
  final AcademicVerificationEntity verification;

  const AcademicVerificationNoRequestBody({
    super.key,
    required this.verification,
  });

  Future<void> _pickImage(
    BuildContext context, {
    required void Function(String path) onPicked,
  }) async {
    debugPrint(
      '============ AcademicVerificationNoRequestBody._pickImage ============',
    );

    final path = await sl<FilePickerService>().pickSingleImagePath();

    debugPrint('→ selected path: $path');

    if (path == null || !context.mounted) {
      debugPrint('→ image selection cancelled');
      debugPrint(
        '=====================================================================',
      );
      return;
    }

    onPicked(path);

    debugPrint('✓ image path saved');
    debugPrint(
      '=====================================================================',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicVerificationCubit, AcademicVerificationState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.03),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const AcademicVerificationHeader(),

                    SizedBox(height: SizeConfig.h(0.02)),

                    SizedBox(
                      width: double.infinity,
                      child: CustomTextWidget(
                        'وثّق مؤهلك الأكاديمي',
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
                        'أرفق صورة واضحة للشهادة الجامعية والوجه الأمامي لهويتك الشخصية.',
                        color: context.appColors.blackTogreyMedium,
                        fontSize: SizeConfig.text(0.04),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.02)),

                    OnboardingImagePickerField(
                      title: 'الشهادة الجامعية',
                      hintText: 'يرجى إرفاق شهادتك الجامعية...',
                      imagePath: state.certificateImagePath,
                      onTap: state.isSubmitLoading
                          ? () {}
                          : () async {
                              await _pickImage(
                                context,
                                onPicked: (path) {
                                  context
                                      .read<AcademicVerificationCubit>()
                                      .certificateImageChanged(path);
                                },
                              );
                            },
                    ),

                    SizedBox(height: SizeConfig.h(0.02)),

                    OnboardingImagePickerField(
                      title: 'الهوية الشخصية',
                      hintText: 'يرجى إرفاق الوجه الأمامي للهوية الشخصية...',
                      imagePath: state.identityImagePath,
                      onTap: state.isSubmitLoading
                          ? () {}
                          : () async {
                              await _pickImage(
                                context,
                                onPicked: (path) {
                                  context
                                      .read<AcademicVerificationCubit>()
                                      .identityImageChanged(path);
                                },
                              );
                            },
                    ),

                    SizedBox(height: SizeConfig.h(0.02)),
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
                      padding:  EdgeInsets.all(SizeConfig.h(0.008)),
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
