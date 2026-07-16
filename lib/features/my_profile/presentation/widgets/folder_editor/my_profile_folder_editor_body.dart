import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_folder_color_picker.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_folder_color_preview.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_folder_name_field.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_folder_visibility_switch.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/folder_editor/my_profile_selected_tests_section.dart';

class MyProfileFolderEditorBody extends StatelessWidget {
  final int userId;
  const MyProfileFolderEditorBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileFolderEditorCubit, MyProfileFolderEditorState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.035),
            vertical: SizeConfig.h(0.012),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const MyProfileFolderColorPreview(),

              SizedBox(height: SizeConfig.h(0.018)),

              _SectionLabel(title: 'الاسم'),

              SizedBox(height: SizeConfig.h(0.006)),

              const MyProfileFolderNameField(),

              SizedBox(height: SizeConfig.h(0.018)),

              _SectionLabel(title: 'اللون'),

              SizedBox(height: SizeConfig.h(0.008)),

              const MyProfileFolderColorPicker(),

              SizedBox(height: SizeConfig.h(0.018)),

              const MyProfileFolderVisibilitySwitch(),

              SizedBox(height: SizeConfig.h(0.022)),

              MyProfileSelectedTestsSection(userId: userId),

              SizedBox(height: SizeConfig.h(0.04)),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      title,
      fontFamily: AppFont.elMessiriBold,
      fontSize: SizeConfig.text(0.035),
      color: context.appColors.blackToGrey2Dark,
      textAlign: TextAlign.right,
    );
  }
}
