import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_switch_tile.dart';

class AcademicVerificationApprovedBody extends StatelessWidget {
  final AcademicVerificationEntity verification;

  const AcademicVerificationApprovedBody({
    super.key,
    required this.verification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
        ),
        child: Column(
          children: [
            const AcademicVerificationHeader(),

            SizedBox(height: SizeConfig.h(0.02)),
            Icon(
              Icons.verified_rounded,
              size: 78,
              color: theme.colorScheme.primary,
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            CustomTextWidget(
              'تم تأكيد مستواك العلمي',
              fontWeight: FontWeight.w700,
              color: context.appColors.primaryToPrimaryDark,
            ),

            SizedBox(height: SizeConfig.h(0.01)),

            CustomTextWidget(
              'تمت الموافقة على مستنداتك الأكاديمية وأصبح حسابك موثقًا أكاديميًا.',
              textAlign: TextAlign.center,
              color: context.appColors.blackToGrey2Dark,
              fontSize: SizeConfig.text(0.045),
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            _InformationRow(
              title: 'تاريخ الموافقة',
              value: verification.approvedAt ?? 'غير متوفر',
            ),

            SizedBox(height: SizeConfig.h(0.016)),

            BlocBuilder<AcademicVerificationCubit, AcademicVerificationState>(
              buildWhen: (previous, current) {
                return previous.visibilityStatus != current.visibilityStatus ||
                    previous.verification?.showCertificatePublicly !=
                        current.verification?.showCertificatePublicly;
              },
              builder: (context, state) {
                final currentVerification = state.verification ?? verification;

                return SettingsSwitchTile(
                  title: 'إظهار الشهادة علنًا',
                  subtitle: 'السماح بعرض شهادة التوثيق في ملفك الشخصي.',
                  icon: Icons.remove_red_eye,
                  iconColor: Colors.lightBlue,
                  iconBackgroundColor: Colors.lightBlue.withValues(alpha: .15),
                  value: currentVerification.showCertificatePublicly,
                  onChanged: state.isVisibilityLoading
                      ? null
                      : (value) async {
                          debugPrint(
                            '============ Show certificate publicly changed ============',
                          );
                          debugPrint(
                            '→ old value: '
                            '${currentVerification.showCertificatePublicly}',
                          );
                          debugPrint('→ new value: $value');
                          debugPrint('→ api value: ${value ? 1 : 0}');

                          final isSuccess = await context
                              .read<AcademicVerificationCubit>()
                              .updateCertificateVisibility(value);

                          debugPrint('→ isSuccess: $isSuccess');
                          debugPrint(
                            '===========================================================',
                          );
                        },
                );
              },
            ),
          ],
        ),
      ),
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
