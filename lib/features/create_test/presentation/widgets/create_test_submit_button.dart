import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestSubmitButton extends StatelessWidget {
  const CreateTestSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTestCubit, CreateTestState>(
      buildWhen: (previous, current) {
        return previous.isCreateContentLoading !=
                current.isCreateContentLoading ||
                previous.isUpdateContentLoading != current.isUpdateContentLoading ||
previous.isContentEditMode != current.isContentEditMode ||
            previous.creationMode != current.creationMode ||
            previous.canSubmit != current.canSubmit ||
            previous.isCreateManualTestLoading !=
                current.isCreateManualTestLoading ||
            previous.isUpdateTestLoading != current.isUpdateTestLoading ||
            previous.isEditMode != current.isEditMode;
            
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final appColors = context.appColors;
      final buttonText = state.isUpdateContentMode
    ? 'حفظ التعديلات'
    : state.isEditMode
        ? 'حفظ التعديلات'
        : 'حفظ ومشاركة';

        //final canPress = state.canSubmit && !state.isCreateManualTestLoading;

        final containerColor = isDark ? AppPalette.black : AppPalette.white;

        final enabledButtonColor = appColors.primaryToPrimaryDark;

        final disabledButtonColor = isDark
            ? AppPalette.greyLightDark
            : const Color(0xFFBFD0FF);

        final enabledTextColor = isDark ? AppPalette.black : AppPalette.white;

        final disabledTextColor = isDark
            ? AppPalette.grey2Dark
            : AppPalette.white;
       final isLoading = state.isUpdateContentMode
    ? state.isUpdateContentLoading
    : state.isContentMode
        ? state.isCreateContentLoading
        : state.isEditMode
            ? state.isUpdateTestLoading
            : state.isCreateManualTestLoading;

        final canPress = state.canSubmit && !isLoading;
        return Container(
          padding: EdgeInsets.only(
            left: SizeConfig.w(0.04),
            right: SizeConfig.w(0.04),
            top: SizeConfig.h(0.010),
            bottom: SizeConfig.h(0.014),
          ),
          decoration: BoxDecoration(
            color: containerColor,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.22 : 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: SizeConfig.h(0.052),
            child: ElevatedButton(
              // onPressed: canPress
              //     ? () {
              //         context.read<CreateTestCubit>().submitCreateManualTest();
              //       }
              //     : null,
              onPressed: canPress
                  ? () {
                      context
                          .read<CreateTestCubit>()
                          .submitCreateOrUpdateTest();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabledButtonColor,
                disabledBackgroundColor: disabledButtonColor,
                foregroundColor: enabledTextColor,
                disabledForegroundColor: disabledTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: SizeConfig.w(0.052),
                      height: SizeConfig.w(0.052),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: enabledTextColor,
                      ),
                    )
                  : CustomTextWidget(
                      buttonText,
                      fontSize: SizeConfig.text(0.032),
                      fontWeight: FontWeight.w800,
                      color: canPress ? enabledTextColor : disabledTextColor,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        );
      },
    );
  }
}
