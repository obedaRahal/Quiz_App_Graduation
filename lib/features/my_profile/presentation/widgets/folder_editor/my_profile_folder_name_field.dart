import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';

class MyProfileFolderNameField extends StatefulWidget {
  const MyProfileFolderNameField({super.key});

  @override
  State<MyProfileFolderNameField> createState() =>
      _MyProfileFolderNameFieldState();
}

class _MyProfileFolderNameFieldState extends State<MyProfileFolderNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final name = context.read<MyProfileFolderEditorCubit>().state.name;
    if (_controller.text != name) {
      _controller.text = name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<
        MyProfileFolderEditorCubit,
        MyProfileFolderEditorState>(
      listenWhen: (previous, current) => previous.name != current.name,
      listener: (context, state) {
        if (_controller.text != state.name) {
          _controller.text = state.name;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        }
      },
      child: SizedBox(
        height: SizeConfig.h(0.055),
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.right,
          //textDirection: TextDirection.rtl,
          onChanged: context.read<MyProfileFolderEditorCubit>().nameChanged,
          decoration: InputDecoration(
            hintText: 'ادخل اسم المجلد الخاص بك...',
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(
              Icons.notes_rounded,
              color: AppPalette.greyMedium,
              size: SizeConfig.text(0.05),
            ),
            hintStyle: TextStyle(
              color: AppPalette.greyMedium,
              fontFamily: AppFont.elMessiriRegular,
              fontSize: SizeConfig.text(0.03),
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withOpacity(0.05)
                : AppPalette.grey,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.03),
              vertical: SizeConfig.h(0.012),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    appColors.borderFieldColorNLightToborderFieldColorNDark,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    appColors.borderFieldColorNLightToborderFieldColorNDark,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: appColors.primaryToPrimaryDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}