import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

void showOtherProfileAcademicCertificateBottomSheet({
  required BuildContext context,
  required int userId,
}) {
  final cubit = context.read<OtherProfileCubit>();

  cubit.getOtherProfileAcademicCertificate(userId: userId);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: const OtherProfileAcademicCertificateBottomSheet(),
      );
    },
  );
}

class OtherProfileAcademicCertificateBottomSheet extends StatelessWidget {
  const OtherProfileAcademicCertificateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<OtherProfileCubit, OtherProfileState>(
      listenWhen: (previous, current) =>
          previous.academicCertificateStatus !=
          current.academicCertificateStatus,
      listener: (context, state) {
        if (state.isAcademicCertificateFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر جلب الشهادة الجامعية',
            type: AppValidationSnackBarType.error,
          );

          context.read<OtherProfileCubit>().resetAcademicCertificateState();

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F1F1F) : AppPalette.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.h(0.012)),
                    Container(
                      width: SizeConfig.w(0.12),
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppPalette.greyMedium.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(0.018)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.045),
                      ),
                      child: CustomTextWidget(
                        'الشهادة الجامعية',
                        color: appColors.blackTogreyMedium,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.04),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    CustomDivider(height: 20, thickness: 3, isDashed: true),

                    Expanded(
                      child: _AcademicCertificateContent(
                        scrollController: scrollController,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AcademicCertificateContent extends StatelessWidget {
  final ScrollController scrollController;

  const _AcademicCertificateContent({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.academicCertificateStatus !=
              current.academicCertificateStatus ||
          previous.academicCertificate != current.academicCertificate,
      builder: (context, state) {
        if (state.isAcademicCertificateLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final certificate = state.academicCertificate;

        if (certificate == null) {
          return Center(
            child: CustomTextWidget(
              'لا توجد شهادة متاحة للعرض',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
              fontSize: SizeConfig.text(0.034),
            ),
          );
        }

        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.04),
            vertical: SizeConfig.h(0.018),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.memory(
              certificate.imageBytes,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}