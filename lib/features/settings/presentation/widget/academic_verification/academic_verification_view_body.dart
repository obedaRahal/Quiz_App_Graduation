import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_content.dart';

class AcademicVerificationViewBody extends StatelessWidget {
  const AcademicVerificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcademicVerificationCubit, AcademicVerificationState>(
      // listenWhen: (previous, current) {
      //   return previous.verification != current.verification ||
      //       previous.errorMessage != current.errorMessage ||
      //       previous.submitStatus != current.submitStatus ||
      //       previous.cancelStatus != current.cancelStatus ||
      //       previous.visibilityStatus != current.visibilityStatus;
      // },
      // listener: (context, state) {
      //   debugPrint(
      //     '============ AcademicVerificationViewBody.listener ============',
      //   );
      //   debugPrint('→ isLoading: ${state.isLoading}');
      //   debugPrint('→ verification: ${state.verification}');
      //   debugPrint('→ errorTitle: ${state.errorTitle}');
      //   debugPrint('→ errorMessage: ${state.errorMessage}');
      //   debugPrint('→ submitStatus: ${state.submitStatus}');
      //   debugPrint('→ submitSuccessTitle: ${state.submitSuccessTitle}');
      //   debugPrint('→ submitSuccessMessage: ${state.submitSuccessMessage}');
      //   debugPrint('→ submitErrorTitle: ${state.submitErrorTitle}');
      //   debugPrint('→ submitErrorMessage: ${state.submitErrorMessage}');
      //   debugPrint(
      //     '===============================================================',
      //   );

      //   if (state.isSubmitSuccess) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: state.submitSuccessTitle ?? 'تمت العملية بنجاح',
      //       message:
      //           state.submitSuccessMessage ??
      //           'تم إرسال طلب التوثيق الأكاديمي بنجاح.',
      //       type: AppValidationSnackBarType.success,
      //     );
      //   }

      //   if (state.isSubmitFailure) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: state.submitErrorTitle ?? 'خطأ',
      //       message:
      //           state.submitErrorMessage ?? 'تعذر إرسال طلب التوثيق الأكاديمي.',
      //       type: AppValidationSnackBarType.error,
      //     );
      //   }

      //   if (state.isCancelSuccess) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: state.cancelSuccessTitle ?? 'تمت العملية بنجاح',
      //       message:
      //           state.cancelSuccessMessage ??
      //           'تم إلغاء طلب التوثيق الأكاديمي بنجاح.',
      //       type: AppValidationSnackBarType.success,
      //     );
      //   }

      //   if (state.isCancelFailure) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: state.cancelErrorTitle ?? 'خطأ',
      //       message:
      //           state.cancelErrorMessage ?? 'تعذر إلغاء طلب التوثيق الأكاديمي.',
      //       type: AppValidationSnackBarType.error,
      //     );
      //   }

      //   if (state.isVisibilityFailure) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: state.visibilityErrorTitle ?? 'خطأ',
      //       message:
      //           state.visibilityErrorMessage ??
      //           'تعذر تحديث حالة ظهور الشهادة العلمية.',
      //       type: AppValidationSnackBarType.error,
      //     );
      //   }
      // },
      listenWhen: (previous, current) {
        return previous.submitStatus != current.submitStatus ||
            previous.cancelStatus != current.cancelStatus ||
            previous.visibilityStatus != current.visibilityStatus;
      },
      listener: (context, state) {
        debugPrint(
          '============ AcademicVerificationViewBody.listener ============',
        );
        debugPrint('→ isLoading: ${state.isLoading}');
        debugPrint('→ verification: ${state.verification}');
        debugPrint('→ errorTitle: ${state.errorTitle}');
        debugPrint('→ errorMessage: ${state.errorMessage}');
        debugPrint('→ submitStatus: ${state.submitStatus}');
        debugPrint('→ submitSuccessTitle: ${state.submitSuccessTitle}');
        debugPrint('→ submitSuccessMessage: ${state.submitSuccessMessage}');
        debugPrint('→ submitErrorTitle: ${state.submitErrorTitle}');
        debugPrint('→ submitErrorMessage: ${state.submitErrorMessage}');
        debugPrint(
          '===============================================================',
        );

        if (state.isSubmitSuccess) {
          showValidationTopSnackBar(
            context,
            title: state.submitSuccessTitle ?? 'تمت العملية بنجاح',
            message:
                state.submitSuccessMessage ??
                'تم إرسال طلب التوثيق الأكاديمي بنجاح.',
            type: AppValidationSnackBarType.success,
          );

          context.read<AcademicVerificationCubit>().resetSubmitStatus();
          return;
        }

        if (state.isSubmitFailure) {
          showValidationTopSnackBar(
            context,
            title: state.submitErrorTitle ?? 'خطأ',
            message:
                state.submitErrorMessage ?? 'تعذر إرسال طلب التوثيق الأكاديمي.',
            type: AppValidationSnackBarType.error,
          );

          context.read<AcademicVerificationCubit>().resetSubmitStatus();
          return;
        }

        if (state.isCancelSuccess) {
          showValidationTopSnackBar(
            context,
            title: state.cancelSuccessTitle ?? 'تمت العملية بنجاح',
            message:
                state.cancelSuccessMessage ??
                'تم إلغاء طلب التوثيق الأكاديمي بنجاح.',
            type: AppValidationSnackBarType.success,
          );

          context.read<AcademicVerificationCubit>().resetCancelStatus();
          return;
        }

        if (state.isCancelFailure) {
          showValidationTopSnackBar(
            context,
            title: state.cancelErrorTitle ?? 'خطأ',
            message:
                state.cancelErrorMessage ?? 'تعذر إلغاء طلب التوثيق الأكاديمي.',
            type: AppValidationSnackBarType.error,
          );

          context.read<AcademicVerificationCubit>().resetCancelStatus();
          return;
        }

        if (state.isVisibilityFailure) {
          showValidationTopSnackBar(
            context,
            title: state.visibilityErrorTitle ?? 'خطأ',
            message:
                state.visibilityErrorMessage ??
                'تعذر تحديث حالة ظهور الشهادة العلمية.',
            type: AppValidationSnackBarType.error,
          );

          context.read<AcademicVerificationCubit>().resetVisibilityStatus();
          return;
        }
      },
      builder: (context, state) {
        debugPrint(
          '============ AcademicVerificationViewBody.builder ============',
        );
        debugPrint('→ isLoading: ${state.isLoading}');
        debugPrint('→ hasVerification: ${state.verification != null}');
        debugPrint('→ hasError: ${state.hasError}');
        debugPrint(
          '==============================================================',
        );

        if (state.isLoading && state.verification == null) {
          return const AcademicVerificationLoadingBody();
        }

        if (state.verification == null) {
          return AcademicVerificationFailureBody(
            title: state.errorTitle ?? 'تعذر تحميل البيانات',
            message:
                state.errorMessage ?? 'تعذر جلب حالة تأكيد المستوى العلمي.',
            onRetry: () {
              context.read<AcademicVerificationCubit>().fetchInitial();
            },
          );
        }

        return AcademicVerificationContent(verification: state.verification!);
      },
    );
  }
}

class AcademicVerificationLoadingBody extends StatelessWidget {
  const AcademicVerificationLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class AcademicVerificationFailureBody extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const AcademicVerificationFailureBody({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
