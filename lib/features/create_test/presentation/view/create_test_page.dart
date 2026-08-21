import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_body.dart';

class CreateTestView extends StatelessWidget {
  final CreateTestInitialArgs? initialArgs;

  const CreateTestView({super.key, this.initialArgs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateTestCubit>(
      create: (_) => sl<CreateTestCubit>()..initializeFromArgs(initialArgs),
      child: BlocListener<CreateTestCubit, CreateTestState>(
        listenWhen: (previous, current) {
          return previous.createContentError != current.createContentError ||
              previous.createContentResponse != current.createContentResponse ||
              previous.createManualTestError != current.createManualTestError ||
              previous.createManualTestResponse !=
                  current.createManualTestResponse ||
              previous.updateTestError != current.updateTestError ||
              previous.updateContentError != current.updateContentError ||
              previous.updateContentResponse != current.updateContentResponse ||
              previous.updateTestResponse != current.updateTestResponse;
        },
        listener: (context, state) {
          final error = state.createManualTestError;
          final response = state.createManualTestResponse;

          final updateError = state.updateTestError;
          final updateResponse = state.updateTestResponse;

          final createContentError = state.createContentError;
          final createContentResponse = state.createContentResponse;

          final updateContentError = state.updateContentError;
          final updateContentResponse = state.updateContentResponse;

          if (updateError != null && updateError.trim().isNotEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'تعذر تعديل الاختبار',
              message: updateError,
              type: AppValidationSnackBarType.error,
            );

            context.read<CreateTestCubit>().clearUpdateTestResult();
            return;
          }

          if (createContentError != null &&
              createContentError.trim().isNotEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'تعذر إنشاء المحتوى',
              message: createContentError,
              type: AppValidationSnackBarType.error,
            );

            context.read<CreateTestCubit>().clearCreateContentResult();
            return;
          }

          if (updateContentError != null &&
              updateContentError.trim().isNotEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'تعذر تعديل المحتوى',
              message: updateContentError,
              type: AppValidationSnackBarType.error,
            );

            context.read<CreateTestCubit>().clearUpdateContentResult();
            return;
          }

          if (createContentResponse != null && createContentResponse.success) {
            showValidationTopSnackBar(
              context,
              title: 'تم إنشاء المحتوى',
              message: createContentResponse.message.trim().isNotEmpty
                  ? createContentResponse.message
                  : 'تم إنشاء المحتوى بنجاح',
              type: AppValidationSnackBarType.success,
            );

            context.read<CreateTestCubit>().clearCreateContentResult();

            Future.delayed(const Duration(milliseconds: 700), () {
              if (!context.mounted) return;

              context.goNamed(AppRouterName.mainLayout);
            });

            return;
          }

          if (updateContentResponse != null && updateContentResponse.success) {
            showValidationTopSnackBar(
              context,
              title: 'تم تعديل المحتوى',
              message: updateContentResponse.message.trim().isNotEmpty
                  ? updateContentResponse.message
                  : 'تم تعديل المحتوى بنجاح',
              type: AppValidationSnackBarType.success,
            );

            context.read<CreateTestCubit>().clearUpdateContentResult();

            Future.delayed(const Duration(milliseconds: 700), () {
              if (!context.mounted) return;

              if (context.canPop()) {
                context.pop(true);
              } else {
                context.goNamed(AppRouterName.mainLayout);
              }
            });

            return;
          }

          if (updateResponse != null && updateResponse.success) {
            showValidationTopSnackBar(
              context,
              title: 'تم حفظ التعديلات',
              message: updateResponse.data.message.trim().isNotEmpty
                  ? updateResponse.data.message
                  : 'تم حفظ التعديلات بنجاح',
              type: AppValidationSnackBarType.success,
            );

            context.read<CreateTestCubit>().clearUpdateTestResult();

            Future.delayed(const Duration(milliseconds: 700), () {
              if (!context.mounted) return;

              if (context.canPop()) {
                context.pop(true);
              } else {
                context.goNamed(AppRouterName.mainLayout);
              }
            });

            return;
          }

          if (error != null && error.trim().isNotEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'تعذر إنشاء الاختبار',
              message: error,
              type: AppValidationSnackBarType.error,
            );

            context.read<CreateTestCubit>().clearCreateManualTestResult();
            return;
          }

          if (response != null && response.success) {
            showValidationTopSnackBar(
              context,
              title: 'تم إنشاء الاختبار',
              message: response.message.trim().isNotEmpty
                  ? response.message
                  : 'تم إنشاء الاختبار بنجاح',
              type: AppValidationSnackBarType.success,
            );

            context.read<CreateTestCubit>().clearCreateManualTestResult();

            if (state.isAiMode) {
              unawaited(context.read<AiGenerationCubit>().clearTask());
            }

            Future.delayed(const Duration(milliseconds: 700), () {
              if (!context.mounted) return;

              context.goNamed(AppRouterName.mainLayout);
            });
          }
        },

        child: const Scaffold(body: SafeArea(child: CreateTestBody())),
      ),
    );
  }
}
