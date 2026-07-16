import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/folder_tab/other_profile_folder_card.dart';

class MyProfileFolderColorPreview extends StatelessWidget {
  const MyProfileFolderColorPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        MyProfileFolderEditorCubit,
        MyProfileFolderEditorState>(
      buildWhen: (previous, current) =>
          previous.colorCode != current.colorCode,
      builder: (context, state) {
        return CustomBackgroundWithChild(
          width: double.infinity,
          border: Border.all(color: AppPalette.greyMedium),
          boxShadow: [
            BoxShadow(
              color: _parseHexColor(state.colorCode),
              blurRadius: 4
            )
          ],
          height: SizeConfig.h(0.105),
          backgroundColor: _parseHexColor(state.colorCode),
          borderRadius: BorderRadius.circular(8),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.04)),
          child: Align(
            alignment: Alignment.centerRight,
            child: ColoredFolderSvg(
              assetPath: AppImage.emptyFolder,
              topColor: _darken(_parseHexColor(state.colorCode)),
              width: SizeConfig.w(0.12),
              height: SizeConfig.w(0.12),
            ),
          ),
        );
      },
    );
  }

  Color _parseHexColor(String value, {Color fallback = const Color(0xFF5582FF)}) {
    var hex = value.trim();
    if (hex.isEmpty) return fallback;
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) hex = 'FF$hex';

    final colorValue = int.tryParse(hex, radix: 16);
    if (colorValue == null) return fallback;

    return Color(colorValue);
  }

  Color _darken(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red * 0.75).round(),
      (color.green * 0.75).round(),
      (color.blue * 0.75).round(),
    );
  }
}