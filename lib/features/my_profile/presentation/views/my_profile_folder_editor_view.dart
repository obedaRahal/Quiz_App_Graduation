import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_editor_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_folder_editor_body.dart';

class MyProfileFolderEditorView extends StatefulWidget {
  final MyProfileFolderEditorRouteArgs args;

  const MyProfileFolderEditorView({super.key, required this.args});

  @override
  State<MyProfileFolderEditorView> createState() =>
      _MyProfileFolderEditorViewState();
}

class _MyProfileFolderEditorViewState extends State<MyProfileFolderEditorView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyProfileFolderEditorCubit>().init(widget.args);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child:
            BlocConsumer<
              MyProfileFolderEditorCubit,
              MyProfileFolderEditorState
            >(
              listenWhen: (previous, current) =>
                  previous.submitStatus != current.submitStatus,
              listener: (context, state) {
                if (state.isSubmitFailure) {
                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? 'خطأ',
                    message: state.errorMessage ?? 'تعذر تنفيذ العملية',
                    type: AppValidationSnackBarType.error,
                  );

                  Future.microtask(() {
                    if (context.mounted) {
                      context
                          .read<MyProfileFolderEditorCubit>()
                          .resetSubmitState();
                    }
                  });
                }

                if (state.isSubmitSuccess) {
                  showValidationTopSnackBar(
                    context,
                    title: 'نجاح',
                    message: state.isCreateMode
                        ? 'تم إنشاء المجلد بنجاح'
                        : 'تم تعديل المجلد بنجاح',
                    type: AppValidationSnackBarType.success,
                  );

                  Navigator.of(context).pop(true);
                }
              },

              buildWhen: (previous, current) =>
                  previous.pageTitle != current.pageTitle ||
                  previous.canSubmit != current.canSubmit ||
                  previous.hasChanges != current.hasChanges ||
                  previous.isSubmitLoading != current.isSubmitLoading,
              builder: (context, state) {
                final isButtonEnabled =
                    state.canSubmit &&
                    state.hasChanges &&
                    !state.isSubmitLoading;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.03),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeaderActionButton(
                            icon: Icons.arrow_back_ios_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          CustomTextWidget(
                            state.pageTitle,
                            color: context.appColors.blackToGrey2Dark,
                            fontFamily: AppFont.elMessiriBold,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: MyProfileFolderEditorBody(
                        userId: widget.args.userId,
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.035),
                        vertical: SizeConfig.h(0.012),
                      ),
                      decoration: BoxDecoration(
                        color: appColors.whiteToblack,
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? AppPalette.greyMediumDark
                                : AppPalette.greyBorderCart,
                            blurRadius: 4,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: CustomButtonWidget(
                        width: double.infinity,
                        backgroundColor: isButtonEnabled
                            ? appColors.primaryToPrimaryDark
                            : appColors.greyToGreyMediumDark,
                        childHorizontalPad: SizeConfig.w(0.04),
                        childVerticalPad: SizeConfig.w(0.013),
                        borderRadius: 6,
                        onTap: isButtonEnabled
                            ? () {
                                debugPrint('submit folder editor');
                                context
                                    .read<MyProfileFolderEditorCubit>()
                                    .submitFolderEditor();
                              }
                            : () {},
                        child: state.isSubmitLoading
                            ? SizedBox(
                                width: SizeConfig.w(0.045),
                                height: SizeConfig.w(0.045),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppPalette.white,
                                ),
                              )
                            : CustomTextWidget(
                                state.submitButtonTitle,
                                fontSize: SizeConfig.text(0.03),
                                color: isButtonEnabled
                                    ? appColors.whiteToblack
                                    : AppPalette.greyMedium,
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }
}
