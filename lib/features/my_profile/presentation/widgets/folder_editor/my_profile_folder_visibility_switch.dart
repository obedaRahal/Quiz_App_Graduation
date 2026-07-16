import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';

class MyProfileFolderVisibilitySwitch extends StatelessWidget {
  const MyProfileFolderVisibilitySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MyProfileFolderEditorCubit, MyProfileFolderEditorState>(
      buildWhen: (previous, current) => previous.isPublic != current.isPublic,
      builder: (context, state) {
        return CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: isDark
              ? Colors.white.withOpacity(0.05)
              : AppPalette.grey,
          borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.025),
            vertical: SizeConfig.h(0.008),
          ),
          border: Border.all(
            color: appColors.borderFieldColorNLightToborderFieldColorNDark,
          ),
          child: Row(
            children: [
              Switch(
                value: state.isPublic,
                activeColor: appColors.primaryToPrimaryDark,
                onChanged: state.isEditMode && state.originalIsPublic
                    ? null
                    : context
                          .read<MyProfileFolderEditorCubit>()
                          .visibilityChanged,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomTextWidget(
                      'نشر المجلد',
                      color: appColors.blackToGrey2Dark,
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.033),
                    ),
                    CustomTextWidget(
                      state.isPublic
                          ? 'يمكن للمستخدمين مشاهدة هذا المجلد'
                          : 'هذا المجلد خاص بك فقط',
                      color: AppPalette.greyMedium,
                      fontSize: SizeConfig.text(0.026),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.w(0.02)),

              Icon(
                state.isPublic
                    ? Icons.public_rounded
                    : Icons.lock_outline_rounded,
                color: AppPalette.greyMedium,
                size: SizeConfig.w(0.05),
              ),
            ],
          ),
        );
      },
    );
  }
}
