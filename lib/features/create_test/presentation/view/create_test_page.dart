import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';
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
            _showCreateTestSnackBar(
              context: context,
              message: updateError,
              backgroundColor: AppPalette.red,
            );

            context.read<CreateTestCubit>().clearUpdateTestResult();
            return;
          }
          if (createContentError != null &&
              createContentError.trim().isNotEmpty) {
            _showCreateTestSnackBar(
              context: context,
              message: createContentError,
              backgroundColor: AppPalette.red,
            );

            context.read<CreateTestCubit>().clearCreateContentResult();
            return;
          }
          if (updateContentError != null &&
              updateContentError.trim().isNotEmpty) {
            _showCreateTestSnackBar(
              context: context,
              message: updateContentError,
              backgroundColor: AppPalette.red,
            );

            context.read<CreateTestCubit>().clearUpdateContentResult();
            return;
          }

          if (createContentResponse != null && createContentResponse.success) {
            _showCreateTestSnackBar(
              context: context,
              message: createContentResponse.message.trim().isNotEmpty
                  ? createContentResponse.message
                  : 'تم إنشاء المحتوى بنجاح',
              backgroundColor: AppPalette.green,
            );

            context.read<CreateTestCubit>().clearCreateContentResult();

            Future.delayed(const Duration(milliseconds: 700), () {
              if (!context.mounted) return;
              context.goNamed(AppRouterName.mainLayout);
            });

            return;
          }
          if (updateContentResponse != null && updateContentResponse.success) {
            _showCreateTestSnackBar(
              context: context,
              message: updateContentResponse.message.trim().isNotEmpty
                  ? updateContentResponse.message
                  : 'تم تعديل المحتوى بنجاح',
              backgroundColor: AppPalette.green,
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
            _showCreateTestSnackBar(
              context: context,
              message: updateResponse.data.message.trim().isNotEmpty
                  ? updateResponse.data.message
                  : 'تم حفظ التعديلات بنجاح',
              backgroundColor: AppPalette.green,
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
          }
          if (error != null && error.trim().isNotEmpty) {
            _showCreateTestSnackBar(
              context: context,
              message: error,
              backgroundColor: AppPalette.red,
            );

            context.read<CreateTestCubit>().clearCreateManualTestResult();
            return;
          }

          if (response != null && response.success) {
            _showCreateTestSnackBar(
              context: context,
              message: response.message.trim().isNotEmpty
                  ? response.message
                  : 'تم إنشاء الاختبار بنجاح',
              backgroundColor: AppPalette.green,
            );

            context.read<CreateTestCubit>().clearCreateManualTestResult();

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

void _showCreateTestSnackBar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.014),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.014),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomTextWidget(
          message,
          fontSize: SizeConfig.text(0.031),
          fontWeight: FontWeight.w800,
          color: isDark ? AppPalette.black : AppPalette.white,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: 3,
        ),
      ),
    ),
  );
}
